# Boots a first-boot image with a clone of its volume attached, at first boot
# and at a later boot. The initrd must stop before systemd-repart and leave
# both disks as they were.
{
  config,
  lib,
  hostPkgs,
  ...
}:

let
  pkgs = config.node.pkgs;

  imageCfg =
    (import ../lib/eval-config.nix {
      system = null;
      modules = [
        ../maintainers/scripts/ec2/amazon-image.nix
        ../modules/profiles/qemu-guest.nix
        {
          amazonImage = {
            store = "erofs";
            root = "first-boot";
            format = "qcow2";
          };
          nix.enable = false;
          nixpkgs.pkgs = pkgs;
        }
      ];
    }).config;

  image = "${imageCfg.system.build.amazonImage}/${imageCfg.image.fileName}";
in
{
  name = "ec2-image-root-first-boot-clone";
  meta.maintainers = with lib.maintainers; [
    roberth
    arianvp
  ];

  # Only provides the QEMU package. The test starts its own machine.
  nodes.machine = { };

  testScript =
    { nodes, ... }:
    ''
      import json
      import os
      import shutil
      import subprocess
      import tempfile

      QEMU = "${nodes.machine.virtualisation.qemu.package}"
      QEMU_IMG = f"{QEMU}/bin/qemu-img"

      state_dir = tempfile.TemporaryDirectory()
      state = state_dir.name

      # With read-only variables, OVMF keeps them in a file on the ESP instead.
      variables = os.path.join(state, "variables.fd")
      shutil.copy("${hostPkgs.OVMF.variables}", variables)
      os.chmod(variables, 0o644)

      def new_disk(name):
          path = os.path.join(state, f"{name}.qcow2")
          subprocess.check_call([
              QEMU_IMG, "create", "-f", "qcow2", "-F", "qcow2",
              "-o", "backing_file=${image}", path, "4G"
          ])
          return path

      def start(disks):
          return create_machine(
              f"{QEMU}/bin/qemu-kvm -m 1024"
              + " -drive if=pflash,format=raw,unit=0,readonly=on,file=${hostPkgs.OVMF.firmware}"
              + f" -drive if=pflash,format=raw,unit=1,file={variables}"
              + "".join(f" -drive file={path},if=virtio,werror=report" for path in disks)
              + " $QEMU_OPTS"
          )

      def partition_names(path):
          with tempfile.TemporaryDirectory() as d:
              head = os.path.join(d, "head.raw")
              subprocess.check_call([QEMU_IMG, "dd", "-f", "qcow2", "-O", "raw", "bs=1M", "count=1", f"if={path}", f"of={head}"])
              os.truncate(head, 4 * 1024**3)
              table = json.loads(subprocess.check_output(["${hostPkgs.util-linux}/bin/sfdisk", "-J", head]))
          return [p.get("name") for p in table["partitiontable"]["partitions"]]

      def assert_refused(disks, reference):
          """The initrd stops before systemd-repart, and no disk differs from reference."""
          machine = start(disks)
          machine.start()
          machine.wait_for_console_text("/dev/vda /dev/vdb all have a nix-store partition")
          # systemd colours unit names on the console.
          machine.wait_for_console_text("Dependency failed for .*Repartition Root Disk")
          machine.wait_for_console_text("Emergency Mode")
          machine.crash()
          for path in disks:
              out = subprocess.check_output([QEMU_IMG, "compare", path, reference], text=True)
              assert "identical" in out, (path, out)

      with subtest("A clone of the image at first boot"):
          assert_refused([new_disk("boot"), new_disk("clone")], "${image}")

      with subtest("A clone of the booted volume at a later boot"):
          boot = new_disk("booted")
          machine = start([boot])
          machine.start()
          machine.wait_for_console_text("Finished .*Repartition Root Disk")
          machine.wait_for_console_text("Reached target .*Initrd Root File System")
          machine.crash()
          assert "nixos" in partition_names(boot), partition_names(boot)

          reference = os.path.join(state, "reference.qcow2")
          clone = os.path.join(state, "booted-clone.qcow2")
          shutil.copy(boot, reference)
          shutil.copy(boot, clone)
          assert_refused([boot, clone], reference)
    '';
}
