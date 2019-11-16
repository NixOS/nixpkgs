# Test for NixOS' container support.

import ./make-test.nix ({ pkgs, ...} : {
  name = "containers-tmpfs";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ kampka ];
  };

  machine =
    { pkgs, ... }:
    { imports = [ ../modules/installer/cd-dvd/channel.nix ];
      virtualisation.writableStore = true;
      virtualisation.memorySize = 768;

      containers.tmpfs =
        {
          autoStart = true;
          tmpfs = [
            # Mount var as a tmpfs
            "/var"

            # Add a nested mount inside a tmpfs
            "/var/log"

            # Add a tmpfs on a path that does not exist
            "/some/random/path"
          ];
          config = { };
        };

      virtualisation.pathsInNixDB = [ pkgs.stdenv ];
    };

  testScript =
    ''
      $machine->waitForUnit("default.target");
      $machine->succeed("nixos-container list") =~ /tmpfs/ or die;

      # Start the tmpfs container.
      #$machine->succeed("nixos-container status tmpfs") =~ /up/ or die;

      # Verify that /var is mounted as a tmpfs
      #$machine->succeed("nixos-container run tmpfs -- systemctl status var.mount --no-pager 2>/dev/null") =~ /What: tmpfs/ or die;
      $machine->succeed("nixos-container run tmpfs -- mountpoint -q /var 2>/dev/null");

      # Verify that /var/log is mounted as a tmpfs
      $machine->succeed("nixos-container run tmpfs -- systemctl status var-log.mount --no-pager 2>/dev/null") =~ /What: tmpfs/ or die;
      $machine->succeed("nixos-container run tmpfs -- mountpoint -q /var/log 2>/dev/null");

      # Verify that /some/random/path is mounted as a tmpfs
      $machine->succeed("nixos-container run tmpfs -- systemctl status some-random-path.mount --no-pager 2>/dev/null") =~ /What: tmpfs/ or die;
      $machine->succeed("nixos-container run tmpfs -- mountpoint -q /some/random/path 2>/dev/null");

      # Verify that files created in the container in a non-tmpfs directory are visible on the host.
      # This establishes legitimacy for the following tests
      $machine->succeed("nixos-container run tmpfs -- touch /root/test.file 2>/dev/null");
      $machine->succeed("nixos-container run tmpfs -- ls -l  /root | grep -q test.file 2>/dev/null");
      $machine->succeed("test -e /var/lib/containers/tmpfs/root/test.file");


      # Verify that /some/random/path is writable and that files created there
      # are not in the hosts container dir but in the tmpfs
      $machine->succeed("nixos-container run tmpfs -- touch /some/random/path/test.file 2>/dev/null");
      $machine->succeed("nixos-container run tmpfs -- test -e /some/random/path/test.file 2>/dev/null");

      $machine->fail("test -e /var/lib/containers/tmpfs/some/random/path/test.file");

      # Verify that files created in the hosts container dir in a path where a tmpfs file system has been mounted
      # are not visible to the container as the do not exist in the tmpfs
      $machine->succeed("touch /var/lib/containers/tmpfs/var/test.file");

      $machine->succeed("test -e /var/lib/containers/tmpfs/var/test.file");
      $machine->succeed("ls -l /var/lib/containers/tmpfs/var/ | grep -q test.file 2>/dev/null");

      $machine->fail("nixos-container run tmpfs -- ls -l /var | grep -q test.file 2>/dev/null");

    '';

})
