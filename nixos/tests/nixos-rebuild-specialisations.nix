{ hostPkgs, ... }:
{
  name = "nixos-rebuild-specialisations";

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

              environment.systemPackages = [
                (pkgs.writeShellScriptBin "parent" "")
              ];

              specialisation.foo = {
                inheritParentConfig = true;

                configuration = { ... }: {
                  environment.systemPackages = [
                    (pkgs.writeShellScriptBin "foo" "")
                  ];
                };
              };

              specialisation.bar = {
                inheritParentConfig = true;

                configuration = { ... }: {
                  environment.systemPackages = [
                    (pkgs.writeShellScriptBin "bar" "")
                  ];
                };
              };
            }
          '';

    in
    # python
    ''
      machine.start()
      machine.succeed("udevadm settle")
      machine.wait_for_unit("multi-user.target")

      machine.succeed("nixos-generate-config")
      machine.copy_from_host(
          "${configFile}",
          "/etc/nixos/configuration.nix",
      )

      with subtest("Switch to the base system"):
          machine.succeed("nixos-rebuild switch")
          machine.succeed("parent")
          machine.fail("foo")
          machine.fail("bar")

      with subtest("Switch from base system into a specialization"):
          machine.succeed("nixos-rebuild switch --specialisation foo")
          machine.succeed("parent")
          machine.succeed("foo")
          machine.fail("bar")

      with subtest("Switch from specialization into another specialization"):
          machine.succeed("nixos-rebuild switch -c bar")
          machine.succeed("parent")
          machine.fail("foo")
          machine.succeed("bar")

      with subtest("Switch from specialization into the base system"):
          machine.succeed("nixos-rebuild switch")
          machine.succeed("parent")
          machine.fail("foo")
          machine.fail("bar")

      with subtest("Switch into specialization using `nixos-rebuild test`"):
          machine.succeed("nixos-rebuild test --specialisation foo")
          machine.succeed("parent")
          machine.succeed("foo")
          machine.fail("bar")

      with subtest("Make sure nonsense command combinations are forbidden"):
          machine.fail("nixos-rebuild boot --specialisation foo")
          machine.fail("nixos-rebuild boot -c foo")
    '';
}
