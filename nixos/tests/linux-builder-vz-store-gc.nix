{ lib, ... }:

{
  # Strictly speaking, this is not a precise test for VZ builder, but we don't
  # have vzvm backend for nixos tests, so we use qemu here, with config that
  # matches linux-builder-vz disk layout.
  name = "linux-builder-vz-store-gc";

  nodes.machine = {
    virtualisation = {
      # Match the vz-vm drive order: the read-only store image is /dev/vda,
      # followed by the writable data disk at /dev/vdb.
      diskImage = null;
      useNixStoreImage = true;
      writableStore = true;
      writableStoreUseTmpfs = false;
      emptyDiskImages = [ 1024 ];

      fileSystems = import ../modules/virtualisation/vz-vm-file-systems.nix {
        inherit lib;
        diskImage = "./nixos.qcow2";
        sharedDirectories = { };
        writableStoreUseTmpfs = false;
      };
    };
  };

  testScript = ''
    machine.start(allow_reboot=True)
    machine.wait_for_unit("multi-user.target")

    def kernel_param(name):
        return machine.succeed(
            f"grep -oE '(^| ){name}=[^ ]+' /proc/cmdline | cut -d= -f2-"
        ).strip()

    reg_info = kernel_param("regInfo")
    init = kernel_param("init")

    def boot_path_status():
        return {
            "regInfo": machine.execute(f"test -f {reg_info}")[0] == 0,
            "init": machine.execute(f"test -x {init}")[0] == 0,
        }

    assert all(boot_path_status().values())

    with subtest("garbage collection before reboot"):
        machine.succeed("nix-collect-garbage")
        before_reboot = boot_path_status()

    machine.reboot()
    machine.wait_for_unit("multi-user.target")

    with subtest("garbage collection after reboot"):
        machine.succeed("nix-collect-garbage")
        after_reboot = boot_path_status()

    results = {
        "before reboot": before_reboot,
        "after reboot": after_reboot,
    }
    assert all(all(paths.values()) for paths in results.values()), results
  '';
}
