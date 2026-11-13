import pathlib
from typing import Any, Literal

import testthing
from test_driver.errors import MachineError

from image_test_driver.machine.base import BaseMachine
from image_test_driver.machine.services import SystemdMachine


class QemuMachine(SystemdMachine, BaseMachine):
    """A cloud image booted by `test.thing`."""

    def __init__(
        self,
        *,
        name: str,
        image: str,
        logger: Any,
        out_dir: Any,
        cpus: int = 2,
        memory: str = "2G",
        boot: Literal["efi", "mbr"] = "efi",
        snapshot: bool = False,
        networking: bool = False,
        credentials: dict[str, str] | None = None,
        cloud_init: dict[str, object] | None = None,
        timeout: float = 120.0,
    ) -> None:
        super().__init__(name=name, logger=logger, out_dir=out_dir)
        self.image = image
        self.cpus = cpus
        self.memory = memory
        self.boot = boot
        self.snapshot = snapshot
        self.networking = networking
        self.credentials = credentials or {}
        self.cloud_init = cloud_init
        self.timeout = timeout
        self._ipc: Any = None
        self._vm: Any = None

    async def start(self) -> None:
        with self.nested("starting VM"):
            self._ipc = testthing.IpcDirectory()
            ipc = self._ipc.__enter__()
            ui = testthing.UI(status_messages=False, verbose=False)
            self._vm = testthing.VirtualMachine(
                pathlib.Path(self.image),
                ipc=ipc,
                boot=self.boot,
                credentials=self.credentials,
                cpus=self.cpus,
                memory=self.memory,
                networks=(testthing.Network.user(),) if self.networking else (),
                cloud_init_user_data=self.cloud_init,
                snapshot=self.snapshot,
                timeout=self.timeout,
                ui=ui,
            )
            await self._vm.__aenter__()

    async def shutdown(self) -> None:
        if self._vm is not None:
            with self.nested("shutting down VM"):
                await self._vm.__aexit__(None, None, None)
            self._vm = None
        if self._ipc is not None:
            self._ipc.__exit__(None, None, None)
            self._ipc = None

    async def _run(
        self, argv: list[str], *, input: bytes | None = None
    ) -> tuple[int, bytes]:
        assert self._vm is not None, "machine is not running"
        command = argv[-1]
        try:
            output = await self._vm.execute(
                command, input=input or b"", check=True, stdin=None
            )
        except testthing.SubprocessError as exc:
            return exc.returncode, exc.output or b""
        return 0, output.encode()

    async def copy_from_host(self, source: str, target: str) -> None:
        """Copy a local file to `target` in the guest."""
        assert self._vm is not None, "machine is not running"
        local = pathlib.Path(source)
        destination = pathlib.PurePosixPath(target)
        remote_directory = str(destination.parent)

        await self._vm.upload(local, target_directory=remote_directory)

        uploaded = destination.parent / local.name
        if str(uploaded) != str(destination):
            # We avoid `mv x x` by comparing first.
            await self._vm.execute("mv", str(uploaded), str(destination))

    async def copy_from_machine(self, source: str, target_dir: str = "") -> None:
        """Copy a guest file into the test output, under `target_dir`."""
        assert self._vm is not None, "machine is not running"
        # We do lexical checks here because `resolve()` would interact with the filesystem.
        # It's not meant to be a security check but a help for genuine mistakes.
        if (
            pathlib.PurePosixPath(target_dir).is_absolute()
            or ".." in pathlib.PurePosixPath(target_dir).parts
        ):
            raise MachineError(
                f"{self.name}: refusing to write outside the output directory: "
                f"{target_dir!r}"
            )
        destination = pathlib.Path(self.out_dir) / target_dir
        destination.mkdir(parents=True, exist_ok=True)
        await self._vm.scp(f"{self._vm.get_id()}:{source}", destination)

    async def reboot(self) -> None:
        assert self._vm is not None, "machine is not running"
        with self.nested("rebooting VM"):
            await self._vm.reboot()
