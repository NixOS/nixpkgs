# Test for NixOS' container support.

import ./make-test.nix ({ pkgs, ...} : {
  name = "containers-imperative";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ aristid aszlig eelco kampfschlaefer ];
  };

  machine =
    { config, pkgs, lib, ... }:
    { imports = [ ../modules/installer/cd-dvd/channel.nix ];

      # XXX: Sandbox setup fails while trying to hardlink files from the host's
      #      store file system into the prepared chroot directory.
      nix.useSandbox = false;
      nix.binaryCaches = []; # don't try to access cache.nixos.org

      virtualisation.writableStore = true;
      virtualisation.memorySize = 1024;
      # Make sure we always have all the required dependencies for creating a
      # container available within the VM, because we don't have network access.
      virtualisation.pathsInNixDB = let
        emptyContainer = import ../lib/eval-config.nix {
          inherit (config.nixpkgs.localSystem) system;
          modules = lib.singleton {
            containers.foo.config = {
              system.stateVersion = "18.03";
            };
          };
        };
      in with pkgs; [
        stdenv stdenvNoCC emptyContainer.config.containers.foo.path
        libxslt desktop-file-utils texinfo docbook5 libxml2
        docbook_xsl_ns xorg.lndir documentation-highlighter
      ];
    };

  testScript = let
    tmpfilesContainerConfig = pkgs.writeText "container-config-tmpfiles" ''
      {
        systemd.tmpfiles.rules = [ "d /foo - - - - -" ];
        systemd.services.foo = {
          serviceConfig.Type = "oneshot";
          script = "ls -al /foo";
          wantedBy = [ "multi-user.target" ];
        };
      }
    ''; in
    ''
      # Make sure we have a NixOS tree (required by ‘nixos-container create’).
      $machine->succeed("PAGER=cat nix-env -qa -A nixos.hello >&2");

      # Create some containers imperatively.
      my $id1 = $machine->succeed("nixos-container create foo --ensure-unique-name");
      chomp $id1;
      $machine->log("created container $id1");

      my $id2 = $machine->succeed("nixos-container create foo --ensure-unique-name");
      chomp $id2;
      $machine->log("created container $id2");

      die if $id1 eq $id2;

      # Put the root of $id2 into a bind mount.
      $machine->succeed(
        "mv /var/lib/containers/$id2 /id2-bindmount",
        "mount --bind /id2-bindmount /var/lib/containers/$id1"
      );

      my $ip1 = $machine->succeed("nixos-container show-ip $id1");
      chomp $ip1;
      my $ip2 = $machine->succeed("nixos-container show-ip $id2");
      chomp $ip2;
      die if $ip1 eq $ip2;

      # Create a directory and a file we can later check if it still exists
      # after destruction of the container.
      $machine->succeed(
        "mkdir /nested-bindmount",
        "echo important data > /nested-bindmount/dummy",
      );

      # Create a directory with a dummy file and bind-mount it into both
      # containers.
      foreach ($id1, $id2) {
        my $importantPath = "/var/lib/containers/$_/very/important/data";
        $machine->succeed(
          "mkdir -p $importantPath",
          "mount --bind /nested-bindmount $importantPath"
        );
      }

      # Start one of them.
      $machine->succeed("nixos-container start $id1");

      # Execute commands via the root shell.
      $machine->succeed("nixos-container run $id1 -- uname") =~ /Linux/ or die;

      # Execute a nix command via the root shell. (regression test for #40355)
      $machine->succeed("nixos-container run $id1 -- nix-instantiate -E 'derivation { name = \"empty\"; builder = \"false\"; system = \"false\"; }'");

      # Stop and start (regression test for #4989)
      $machine->succeed("nixos-container stop $id1");
      $machine->succeed("nixos-container start $id1");

      # Ensure tmpfiles are present
      $machine->log("creating container tmpfiles");
      $machine->succeed("nixos-container create tmpfiles --config-file ${tmpfilesContainerConfig}");
      $machine->log("created, starting…");
      $machine->succeed("nixos-container start tmpfiles");
      $machine->log("done starting, investigating…");
      $machine->succeed("echo \$(nixos-container run tmpfiles -- systemctl is-active foo.service) | grep -q active;");
      $machine->succeed("nixos-container destroy tmpfiles");

      # Execute commands via the root shell.
      $machine->succeed("nixos-container run $id1 -- uname") =~ /Linux/ or die;

      # Destroy the containers.
      $machine->succeed("nixos-container destroy $id1");
      $machine->succeed("nixos-container destroy $id2");

      $machine->succeed(
        # Check whether destruction of any container has killed important data
        "grep -qF 'important data' /nested-bindmount/dummy",
        # Ensure that the container path is gone
        "test ! -e /var/lib/containers/$id1"
      );
    '';

})
