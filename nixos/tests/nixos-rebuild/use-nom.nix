{ mkConfigFile, ... }:
{
  name = "nixos-rebuild-use-nom";

  imports = [ ./common.nix ];

  nodes.machine = {
    system.tools.nixos-rebuild.useNom = true;
  };

  testScript =
    let
      configFile = mkConfigFile ''
        system.tools.nixos-rebuild.useNom = true;
      '';

      # The debug log line emitted when nix-output-monitor is selected
      marker = "to monitor the build";
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

      with subtest("nom is pinned in the wrapper PATH"):
          machine.succeed("grep -q nix-output-monitor \"$(type -P nixos-rebuild)\"")

      with subtest("Falls back to plain Nix when stderr is not a terminal"):
          output = machine.succeed("nixos-rebuild build -v 2>&1")
          assert "${marker}" not in output, f"nom used without a terminal: {output}"

      with subtest("Uses nom on a terminal"):
          output = machine.succeed("script -qec 'nixos-rebuild build -v' /dev/null")
          assert "${marker}" in output, f"nom not used on a terminal: {output}"

      with subtest("NIXOS_REBUILD_USE_NOM=0 disables nom on a terminal"):
          output = machine.succeed(
              "NIXOS_REBUILD_USE_NOM=0 script -qec 'nixos-rebuild build -v' /dev/null"
          )
          assert "${marker}" not in output, f"nom used despite NIXOS_REBUILD_USE_NOM=0: {output}"
    '';
}
