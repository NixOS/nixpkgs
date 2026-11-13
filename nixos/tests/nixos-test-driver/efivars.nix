{ pkgs, lib, ... }:
let
  vendorUuid = "a19f72f8-b554-4bd7-a0c2-2762bd854691";
  varName = "Demo";
  readWriteVar = pkgs.writers.writePython3 "read-increment-efi-var" { } ''
    import os
    import sys
    import fcntl
    import array

    if len(sys.argv) != 3:
        print(f"Usage: {sys.argv[0]} NAME UUID", file=sys.stderr)
        sys.exit(1)

    name = sys.argv[1]
    uuid = sys.argv[2]
    path = f"/sys/firmware/efi/efivars/{name}-{uuid}"

    FS_IMMUTABLE_FL = 0x00000010
    FS_IOC_GETFLAGS = 0x80086601
    FS_IOC_SETFLAGS = 0x40086602

    if not os.path.exists(path):
        print(f"{path}: does not exist", file=sys.stderr)
        sys.exit(1)

    with open(path, "rb") as f:
        data = f.read()

    # The first 4 bytes are attributes, the rest is the data
    if data[4:] != b"\x2a":
        print(f"0x2a value expected, got {data[4:]!r}", file=sys.stderr)
        sys.exit(1)

    fd = os.open(path, os.O_RDONLY)
    arg = array.array("L", [0])
    fcntl.ioctl(fd, FS_IOC_GETFLAGS, arg)
    if arg[0] & FS_IMMUTABLE_FL:
        arg[0] &= ~FS_IMMUTABLE_FL
        fcntl.ioctl(fd, FS_IOC_SETFLAGS, arg)
    os.close(fd)

    with open(path, "wb") as f:
        # Write 0x2b
        data = bytes(list(data[:4]) + [0x2b])
        f.write(data)
  '';
in
{
  name = "efivars";

  nodes.machine = {
    boot.loader.efi.canTouchEfiVariables = true;
    virtualisation.useEFIBoot = true;
  };

  testScript = ''
    import uuid
    import unittest

    from test_driver.efi import EfiVariable
    from test_driver.errors import RequestedAssertionFailed


    class TestConcurrentRead(unittest.TestCase):
        def __init__(self, machine):
            super().__init__()
            self.machine = machine

        def test_concurrent_read(self):
            with self.assertRaises(RequestedAssertionFailed):
                self.machine.read_efi_vars()


    vendor_uuid = uuid.UUID('${vendorUuid}')
    machine.create_efi_vars()
    machine.write_efi_vars([
        EfiVariable(
            vendor_uuid=vendor_uuid,
            name="${varName}",
            data=bytes([0x2a]),
            flags=EfiVariable.Flags.NON_VOLATILE | EfiVariable.Flags.BOOTSERVICE_ACCESS | EfiVariable.Flags.RUNTIME_ACCESS,
        )
    ])

    machine.start()
    machine.wait_for_unit("multi-user.target")

    print(machine.succeed('${readWriteVar} "${varName}" "${vendorUuid}"'))

    TestConcurrentRead(machine).test_concurrent_read()
    machine.crash()

    machine.dump_efi_vars()
    vars = machine.read_efi_vars()

    guid = uuid.UUID(bytes=vendor_uuid.bytes_le)
    predicate = lambda v: v.name == "${varName}" and v.vendorUUID == guid
    var = next((v for v in vars if predicate(v)), None)

    if var:
        var.print()
        if var.data == bytes([0x2b]):
            print("Congrats!")
        else:
            raise ValueError("Value 0x2b expected")
    else:
        raise ValueError("Could not find ${varName} variable")
  '';
}
