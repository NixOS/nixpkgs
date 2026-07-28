{ mkConfigFile, ... }:
{
  name = "nixos-rebuild-specialisations";

  imports = [ ./common.nix ];

  testScript =
    let
      configFile = mkConfigFile ''
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
