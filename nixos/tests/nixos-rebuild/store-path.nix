{ mkConfigFile, ... }:
{
  name = "nixos-rebuild-store-path";

  imports = [ ./common.nix ];

  testScript =
    let
      configFile =
        hostname:
        mkConfigFile ''
          networking.hostName = "${hostname}";
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
