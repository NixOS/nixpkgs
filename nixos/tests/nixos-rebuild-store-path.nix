{ hostPkgs, ... }:
{
  name = "nixos-rebuild-store-path";

  # TODO: remove overlay from  nixos/modules/profiles/installation-device.nix
  #        make it a _small package instead, then remove pkgsReadOnly = false;.
  node.pkgsReadOnly = false;

  nodes = {
    machine =
      { lib, pkgs, ... }:
      {
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

        system.switch.enable = true;

        virtualisation = {
          cores = 2;
          memorySize = 4096;
        };
      };
  };

  testScript =
    let
      configFile =
        hostname:
        hostPkgs.writeText "configuration.nix" # nix
          ''
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

              networking.hostName = "${hostname}";
            }
          '';

    in
    # python
    ''
      machine.start()
      machine.succeed("udevadm settle")
      machine.wait_for_unit("multi-user.target")

      machine.succeed("nixos-generate-config")

      with subtest("Build configuration without switching"):
          machine.copy_from_host(
              "${configFile "store-path-test"}",
              "/etc/nixos/configuration.nix",
          )
          store_path = machine.succeed("nix-build '<nixpkgs/nixos>' -A system --no-out-link").strip()
          machine.succeed(f"test -f {store_path}/nixos-version")

      with subtest("Switch using --store-path"):
          machine.succeed(f"nixos-rebuild switch --store-path {store_path}")
          hostname = machine.succeed("cat /etc/hostname").strip()
          assert hostname == "store-path-test", f"Expected hostname 'store-path-test', got '{hostname}'"

      with subtest("Test using --store-path"):
          machine.copy_from_host(
              "${configFile "store-path-test-2"}",
              "/etc/nixos/configuration.nix",
          )
          store_path_2 = machine.succeed("nix-build '<nixpkgs/nixos>' -A system --no-out-link").strip()
          machine.succeed(f"nixos-rebuild test --store-path {store_path_2}")
          hostname = machine.succeed("cat /etc/hostname").strip()
          assert hostname == "store-path-test-2", f"Expected hostname 'store-path-test-2', got '{hostname}'"

      with subtest("Ensure --store-path rejects invalid combinations"):
          machine.fail(f"nixos-rebuild switch --store-path {store_path} --rollback")
          machine.fail(f"nixos-rebuild switch --store-path {store_path} --flake .")
          machine.fail(f"nixos-rebuild build --store-path {store_path}")
    '';
}
