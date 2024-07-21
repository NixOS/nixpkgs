import ./make-test-python.nix ({ pkgs, lib, ... }: {
  name = "containers-imperative";
  meta = {
    maintainers = with lib.maintainers; [ aristid aszlig kampfschlaefer ];
  };

  nodes.machine =
    { config, pkgs, lib, ... }:
    { imports = [ ../modules/installer/cd-dvd/channel.nix ];

      # XXX: Sandbox setup fails while trying to hardlink files from the host's
      #      store file system into the prepared chroot directory.
      nix.settings.sandbox = false;
      nix.settings.substituters = []; # don't try to access cache.nixos.org

      virtualisation.memorySize = 2048;
      virtualisation.writableStore = true;
      # Make sure we always have all the required dependencies for creating a
      # container available within the VM, because we don't have network access.
      virtualisation.additionalPaths = let
        emptyContainer = import ../lib/eval-config.nix {
          modules = lib.singleton {
            nixpkgs = { inherit (config.nixpkgs) localSystem; };

            containers.foo.config = {};
          };

          # The system is inherited from the host above.
          # Set it to null, to remove the "legacy" entrypoint's non-hermetic default.
          system = null;
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
      brokenCfg = pkgs.writeText "broken.nix" ''
        {
          assertions = [
            { assertion = false;
              message = "I never evaluate";
            }
          ];
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
              f"mv /var/lib/nixos-containers/{id2} /id2-bindmount",
              f"mount --bind /id2-bindmount /var/lib/nixos-containers/{id1}",
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
              important_path = f"/var/lib/nixos-containers/{id}/very/important/data"
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

      # clear serial backlog for next tests
      machine.succeed("logger eat console backlog 3ea46eb2-7f82-4f70-b810-3f00e3dd4c4d")
      machine.wait_for_console_text(
          "eat console backlog 3ea46eb2-7f82-4f70-b810-3f00e3dd4c4d"
      )

      with subtest("Stop a container early"):
          machine.succeed(f"nixos-container stop {id1}")
          machine.succeed(f"nixos-container start {id1} >&2 &")
          machine.wait_for_console_text("Stage 2")
          machine.succeed(f"nixos-container stop {id1}")
          machine.wait_for_console_text(f"Container {id1} exited successfully")
          machine.succeed(f"nixos-container start {id1}")

      with subtest("Stop a container without machined (regression test for #109695)"):
          machine.systemctl("stop systemd-machined")
          machine.succeed(f"nixos-container stop {id1}")
          machine.wait_for_console_text(f"Container {id1} has been shut down")
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
          print(machine.succeed("ls -lsa /var/lib/nixos-containers"))
          machine.succeed(f"test ! -e /var/lib/nixos-containers/{id1}")

      with subtest("Ensure that a failed container creation doesn'leave any state"):
          machine.fail(
              "nixos-container create b0rk --config-file ${brokenCfg}"
          )
          machine.succeed("test ! -e /var/lib/nixos-containers/b0rk")
    '';
})
