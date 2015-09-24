import ./make-test.nix ({ pkgs, lib, ...} : {

  meta.maintainers = [ lib.maintainers.eelco ];

  machine = { config, pkgs, ... }: {
    virtualisation.diskSize = 512;
    fileSystems = lib.mkVMOverride {
      "/".autoResize = true;
    };
  };

  testScript =
    ''
      # Create a VM with a 512 MiB disk.
      $machine->start;
      $machine->waitForUnit("multi-user.target");
      my $blocks = $machine->succeed("stat -c %b -f /");
      my $bsize = $machine->succeed("stat -c %S -f /");
      my $size = $blocks * $bsize;
      die "wrong free space $size" if $size < 480 * 1024 * 1024 || $size > 512 * 1024 * 1024;
      $machine->succeed("touch /marker");
      $machine->shutdown;

      # Grow the disk to 1024 MiB.
      system("qemu-img resize vm-state-machine/machine.qcow2 1024M") == 0 or die;

      # Start the VM again and check whether the initrd has correctly
      # grown the root filesystem.
      $machine->start;
      $machine->waitForUnit("multi-user.target");
      $machine->succeed("[ -e /marker ]");
      my $blocks = $machine->succeed("stat -c %b -f /");
      my $size = $blocks * $bsize;
      die "wrong free space $size" if $size < 980 * 1024 * 1024 || $size > 1024 * 1024 * 1024;
    '';
})
