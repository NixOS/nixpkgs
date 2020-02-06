# Test for NixOS' container support.

import ./make-test-python.nix ({ pkgs, ...} : {
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
      '';
    in ''
      with subtest("Make sure we have a NixOS tree (required by ‘nixos-container create’)"):
          machine.succeed("PAGER=cat nix-env -qa -A nixos.hello >&2")

      id1, id2 = None, None

      with subtest("Create some containers imperatively"):
          id1 = machine.succeed("nixos-container create foo --ensure-unique-name").rstrip()
          machine.log(f"created container {id1}")

          id2 = machine.succeed("nixos-container create foo --ensure-unique-name").rstrip()
          machine.log(f"created container {id2}")

          assert id1 != id2

      with subtest(f"Put the root of {id2} into a bind mount"):
          machine.succeed(
              f"mv /var/lib/containers/{id2} /id2-bindmount",
              f"mount --bind /id2-bindmount /var/lib/containers/{id1}",
          )

          ip1 = machine.succeed(f"nixos-container show-ip {id1}").rstrip()
          ip2 = machine.succeed(f"nixos-container show-ip {id2}").rstrip()
          assert ip1 != ip2

      with subtest(
          "Create a directory and a file we can later check if it still exists "
          + "after destruction of the container"
      ):
          machine.succeed("mkdir /nested-bindmount")
          machine.succeed("echo important data > /nested-bindmount/dummy")

      with subtest(
          "Create a directory with a dummy file and bind-mount it into both containers."
      ):
          for id in id1, id2:
              important_path = f"/var/lib/containers/{id}/very/important/data"
              machine.succeed(
                  f"mkdir -p {important_path}",
                  f"mount --bind /nested-bindmount {important_path}",
              )

      with subtest("Start one of them"):
          machine.succeed(f"nixos-container start {id1}")

      with subtest("Execute commands via the root shell"):
          assert "Linux" in machine.succeed(f"nixos-container run {id1} -- uname")

      with subtest("Execute a nix command via the root shell. (regression test for #40355)"):
          machine.succeed(
              f"nixos-container run {id1} -- nix-instantiate -E "
              + '\'derivation { name = "empty"; builder = "false"; system = "false"; }\' '
          )

      with subtest("Stop and start (regression test for #4989)"):
          machine.succeed(f"nixos-container stop {id1}")
          machine.succeed(f"nixos-container start {id1}")

      with subtest("tmpfiles are present"):
          machine.log("creating container tmpfiles")
          machine.succeed(
              "nixos-container create tmpfiles --config-file ${tmpfilesContainerConfig}"
          )
          machine.log("created, starting…")
          machine.succeed("nixos-container start tmpfiles")
          machine.log("done starting, investigating…")
          machine.succeed(
              "echo $(nixos-container run tmpfiles -- systemctl is-active foo.service) | grep -q active;"
          )
          machine.succeed("nixos-container destroy tmpfiles")

      with subtest("Execute commands via the root shell"):
          assert "Linux" in machine.succeed(f"nixos-container run {id1} -- uname")

      with subtest("Destroy the containers"):
          for id in id1, id2:
              machine.succeed(f"nixos-container destroy {id}")

      with subtest("Check whether destruction of any container has killed important data"):
          machine.succeed("grep -qF 'important data' /nested-bindmount/dummy")

      with subtest("Ensure that the container path is gone"):
          print(machine.succeed("ls -lsa /var/lib/containers"))
          machine.succeed(f"test ! -e /var/lib/containers/{id1}")
    '';
})
