- The `qemu-vm.nix` module by default now identifies block devices via
  persistent names available in `/dev/disk/by-*`. Because the rootDevice is
  identified by its filesystem label, it needs to be formatted before the VM is
  started. The functionality of automatically formatting the rootDevice in the
  initrd is removed from the QEMU module. However, for tests that depend on
  this functionality, a test utility for the scripted initrd is added
  (`nixos/tests/common/auto-format-root-device.nix`). To use this in a NixOS
  test, import the module, e.g. `imports = [
  ./common/auto-format-root-device.nix ];` When you use the systemd initrd, you
  can automatically format the root device by setting
  `virtualisation.fileSystems."/".autoFormat = true;`.
