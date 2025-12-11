import binascii
import io
import os.path
import uuid
from pathlib import Path
from typing import Any, TypeVar

from ovmfvartool import (
    AuthenticatedVariable,
    FirmwareVolumeHeader,
    UEFITime,
    VariableStoreHeader,
    resolveUUID,
)

import test_driver.machine

EfiVariableT = TypeVar("EfiVariableT", bound="EfiVariable")


class EfiVariable(AuthenticatedVariable):
    class Flags:
        NON_VOLATILE = 0x1
        BOOTSERVICE_ACCESS = 0x2
        RUNTIME_ACCESS = 0x4
        TIME_BASED_AUTHENTICATED_WRITE_ACCESS = 0x20

    class State:
        VAR_HEADER_VALID_ONLY = 0x7F ^ 0xFF
        VAR_ADDED = 0x40

    volatile = False
    boot_access = False
    runtime_access = False
    hardware_error_record = False
    authenticated_write_access = False
    time_based_authenticated_write_access = False
    append_write = False

    def __init__(
        self,
        vendor_uuid: uuid.UUID | None = None,
        name: str | None = None,
        data: bytes | None = None,
        state: int | None = None,
        flags: int | None = None,
    ) -> None:
        self.magic = 0x55AA
        self.reserved1 = 0
        self.monotonicCount = 0
        self.timestamp = UEFITime()
        self.pubKeyIdx = 0
        self.state = 0
        self.flags = 0

        if vendor_uuid:
            self.vendorUUID = uuid.UUID(bytes=vendor_uuid.bytes_le)

        if state:
            self.state = state ^ 0xFF
        else:
            self.state = (0x40 | 0x80) ^ 0xFF

        if flags:
            self.flags = flags

        if name:
            self.name = name
            self.nameLen = len(name) * 2 + 2

        if data:
            self.data = data
            self.dataLen = len(data)

    def _read_flags(self) -> None:
        if not (self.flags & 0x1):
            self.volatile = True
        if self.flags & 0x2:
            self.boot_access = True
        if self.flags & 0x4:
            self.runtime_access = True
        if self.flags & 0x8:
            self.hardware_error_record = True
        if self.flags & 0x10:
            self.authenticated_write_access = True
        if self.flags & 0x20:
            self.time_based_authenticated_write_access = True
        if self.flags & 0x40:
            self.append_write = True

        self.flags &= ~(0x1 | 0x2 | 0x4 | 0x8 | 0x10 | 0x20 | 0x40)

    @classmethod
    def deserialize(cls: type[EfiVariableT], f: Any) -> EfiVariableT | None:
        # pylint: disable=no-member
        # false positive https://github.com/PyCQA/pylint/issues/981
        ret = super().deserialize(f)
        if ret:
            ret._read_flags()
        return ret

    @classmethod
    def deserializeFromDocument(  # noqa: N802
        cls: type[EfiVariableT], vendor_id: str, name: str, doc: Any
    ) -> EfiVariableT:
        # pylint: disable=no-member
        # false positive https://github.com/PyCQA/pylint/issues/981
        ret = super(cls, cls).deserializeFromDocument(vendor_id, name, doc)
        if ret:
            ret._read_flags()
        return ret


class EfiVars:
    """A container around the ovmf variables"""

    state_path: Path
    machine: "test_driver.machine.Machine"

    def __init__(self, state_path: Path, machine: Any):
        self.state_path = state_path
        self.machine = machine

    def _assert_stopped(self) -> None:
        if self.machine.booted:
            raise Exception(
                "System is currently running and concurrent reads / writes to the OVMF variables is unsupported"
            )

    def read_content(self) -> dict[str, dict[str, EfiVariable]] | None:
        self._assert_stopped()
        try:
            with open(self.state_path, "rb") as f:
                fvh = FirmwareVolumeHeader.deserialize(f)
                vsh = VariableStoreHeader.deserialize(f)
                _ = fvh
                _ = vsh
                variables: dict[str, dict[str, EfiVariable]] = {}

                while True:
                    v = EfiVariable.deserialize(f)
                    if not v:
                        break
                    if v.isDeleted:
                        continue

                    k = resolveUUID(v.vendorUUID)
                    variables.setdefault(k, {})
                    variables[k][v.name] = v

                return variables

        except FileNotFoundError:
            return None

    def create_empty(self) -> None:
        self._assert_stopped()

        if os.path.exists(self.state_path):
            raise Exception("OVMF variables store exists")

        with open(self.state_path, "wb") as fo:
            fm = io.BytesIO(b"\xff" * (528 * 1024))
            fm.write(FirmwareVolumeHeader.create().serialize())
            fm.write(VariableStoreHeader.create().serialize())

            fm.seek(0x41000)
            fm.write(
                binascii.unhexlify(
                    b"2b29589e687c7d49a0ce6500fd9f1b952caf2c64feffffffe00f000000000000"
                )
            )
            fm.seek(0)
            fo.write(fm.read())

    def write(self, add: list[EfiVariable]) -> None:
        self._assert_stopped()

        variables = self.read_content()
        if not variables:
            variables = {}

        for var in add:
            k = resolveUUID(var.vendorUUID)
            variables.setdefault(k, {})
            variables[k][var.name] = var

        with open(self.state_path, "wb") as fo:
            fm = io.BytesIO(b"\xff" * (528 * 1024))
            fm.write(FirmwareVolumeHeader.create().serialize())
            fm.write(VariableStoreHeader.create().serialize())

            for _, vendor in variables.items():
                for _, v in vendor.items():
                    fm.write(v.serialize())
                    if fm.tell() % 4:
                        fm.write(b"\xff" * (4 - (fm.tell() % 4)))
                    assert (fm.tell() % 4) == 0

            fm.seek(0x41000)
            fm.write(
                binascii.unhexlify(
                    b"2b29589e687c7d49a0ce6500fd9f1b952caf2c64feffffffe00f000000000000"
                )
            )
            fm.seek(0)
            fo.write(fm.read())


class EfiGuid:
    from ovmfvartool import (
        gEdkiiVarErrorFlagGuid,
        gEfiAuthenticatedVariableGuid,
        gEfiCertDbGuid,
        gEfiCustomModeEnableGuid,
        gEfiGlobalVariableGuid,
        gEfiImageSecurityDatabaseGuid,
        gEfiIp4Config2ProtocolGuid,
        gEfiIScsiInitiatorNameProtocolGuid,
        gEfiMemoryTypeInformationGuid,
        gEfiSecureBootEnableDisableGuid,
        gEfiSystemNvDataFvGuid,
        gEfiVendorKeysNvGuid,
        gIScsiConfigGuid,
        gMicrosoftVendorGuid,
        gMtcVendorGuid,
        mBmHardDriveBootVariableGuid,
    )
