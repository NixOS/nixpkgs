- The `qemu-vm.nix` module now supports disabling overriding `fileSystems` with
  `virtualisation.fileSystems`. This enables the user to boot VMs from
  "external" disk images not created by the qemu-vm module. You can stop the
  qemu-vm module from overriding `fileSystems` by setting
  `virtualisation.fileSystems = lib.mkForce { };`.
