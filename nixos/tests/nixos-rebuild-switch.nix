import ./make-test-python.nix ({ pkgs, ... }: {
  name = "nixos-rebuild-switch";

  nodes = {
    machine = { lib, pkgs, ... }: {
      imports = [
        ../modules/profiles/installation-device.nix
        ../modules/profiles/base.nix
      ];

      system.includeBuildDependencies = true;

      system.extraDependencies = [
        # Not part of the initial build apparently?
        pkgs.grub2
      ];

      virtualisation = {
        cores = 2;
        memorySize = 2048;
      };
    };
  };

  testScript =
    let
      configFile = gen: pkgs.writeText "configuration.nix" ''
        { lib, pkgs, ... }: {
          imports = [
            ./hardware-configuration.nix
            <nixpkgs/nixos/modules/testing/test-instrumentation.nix>
          ];

          boot.loader.grub = {
            enable = true;
            device = "/dev/vda";
            forceInstall = true;
          };

          documentation.enable = false;

          environment.systemPackages = [
            # make a different config, so that the nixos-rebuild has something to do
            (pkgs.writeShellScriptBin "iAmGeneration" "echo ${gen}")
            # for list-generations parsing
            pkgs.jq
          ];
        }
      '';
      createConfig = gen: ''
          machine.copy_from_host(
              "${configFile gen}",
              "/etc/nixos/configuration.nix",
          )
          '';
      testForBootGeneration = gen: ''
        machine.succeed("""[ "$(nixos-rebuild list-generations --json | jq 'map(select(.current))[0].generation')" -eq ${gen} ]""")
        '';
      testForActiveGeneration = gen: ''
        machine.succeed('[ "$(iAmGeneration)" -eq ${gen} ]')
        '';
    in
    ''
      machine.start()
      machine.succeed("udevadm settle")
      machine.wait_for_unit("multi-user.target")

      machine.succeed("nixos-generate-config")

      with subtest("Does not have a system profile initially"):
          machine.fail("nixos-rebuild list-generations");

      with subtest("Create generation 1"):
          ${createConfig "1"}
          machine.succeed("nixos-rebuild switch")
          ${testForBootGeneration "1"}
          ${testForActiveGeneration "1"}

      with subtest("Create generation 2"):
          ${createConfig "2"}
          machine.succeed("nixos-rebuild switch")
          ${testForBootGeneration "2"}
          ${testForActiveGeneration "2"}

      with subtest("Create generation 3"):
          ${createConfig "3"}
          out = machine.succeed("nixos-rebuild switch 2>&1")
          assert "building the system configuration..." in out
          ${testForBootGeneration "3"}
          ${testForActiveGeneration "3"}

      with subtest("must switch to `--generation 1`"):
          ${createConfig "4"}
          out = machine.succeed("nixos-rebuild switch --generation 1 2>&1")
          assert "building the system configuration..." not in out
          ${testForBootGeneration "1"}
          ${testForActiveGeneration "1"}

      with subtest("`boot --generation 3` must not activate it"):
          machine.succeed("nixos-rebuild boot --generation 3")
          ${testForBootGeneration "3"}
          ${testForActiveGeneration "1"}
          # TODO: QEMU seems to have a tempfs and so after a reboot the content of the disk is lost
          # This also requires adding the parameter `machine.start(allow_reboot = True)`
          # machine.reboot()
          # $ {testForActiveGeneration "3"}

      with subtest("`switch --rollback` must activate previous generation"):
          machine.succeed("nixos-rebuild switch --rollback")
          ${testForBootGeneration "2"}
          ${testForActiveGeneration "2"}
    '';
})
