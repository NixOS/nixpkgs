import ./make-test-python.nix ({ pkgs, ... }: {
  name = "nixos-rebuild-switch";

  nodes = {
    machine = { lib, pkgs, ... }: {
      imports = [
        ../modules/profiles/installation-device.nix
        ../modules/profiles/base.nix
      ];

      nix.settings = {
        substituters = lib.mkForce [ ];
        hashed-mirrors = null;
        connect-timeout = 1;
      };

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
      test_for_generation = gen: ''
        machine.succeed("""[ "$(nixos-rebuild list-generations --json | jq 'map(select(.current))[0].generation')" -eq ${gen} ]""")
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

      with subtest("Switch to the base system with generation number '1'"):
          ${createConfig "1"}
          machine.succeed("nixos-rebuild switch")
          ${test_for_generation "1"}

      with subtest("Switch to the base system with generation number '2'"):
          ${createConfig "2"}
          machine.succeed("nixos-rebuild switch")
          ${test_for_generation "2"}

      with subtest("Switch to the base system with generation number '3'"):
          ${createConfig "3"}
          machine.succeed("nixos-rebuild switch")
          ${test_for_generation "3"}

      with subtest("`switch --generation` must roll back"):
          machine.succeed("nixos-rebuild switch --generation 1")
          ${test_for_generation "1"}

      with subtest("`switch --generation` must switch to newer generation"):
          machine.succeed("nixos-rebuild switch --generation 3")
          ${test_for_generation "3"}

      with subtest("Rollback must succeed"):
          machine.succeed("nixos-rebuild switch --rollback")
          ${test_for_generation "2"}
    '';
})
