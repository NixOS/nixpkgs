{
  lib,
  pkgs,
  ...
}:
{
  name = "reaction-firewall-interaction";

  nodes.machine =
    { config, pkgs, ... }:
    {
      services.reaction = {
        enable = true;
        stopForFirewall = true; # with this enabled restarting firewall will restart reaction
        settingsFiles = [
          "${pkgs.reaction}/share/examples/example.jsonnet"
          # "${pkgs.reaction}/share/examples/example.yml" # can't specify both because conflicts
        ];
        runAsRoot = true;
      };
      networking.firewall.enable = true;
    };

  testScript = # py
    ''
      start_all()
      machine.wait_for_unit("multi-user.target")

      # Verify both services start successfully
      machine.wait_for_unit("firewall.service")
      machine.wait_for_unit("reaction.service")

      # Check reaction chain exists in iptables
      output = machine.succeed("iptables -w -L -n")
      assert "reaction" in output, "reaction chain not found in iptables"

      # Reload firewall and verify there's no issues due to reaction chain
      machine.succeed("systemctl reload firewall")
      output = machine.succeed("journalctl -u reaction.service -u firewall.service --no-pager")
      assert "ERROR" not in output, "firewall reload failed due to reaction"

      # Verify reaction chain still exists after reload
      output = machine.succeed("iptables -w -L -n")
      assert "reaction" in output, "reaction chain missing after firewall reload"

      # Restart firewall and verify reaction restarts as well
      machine.succeed("systemctl restart firewall")
      output = machine.succeed("journalctl -u reaction.service -u firewall.service --no-pager")
      assert "INFO stop command" in output and "INFO start command" in output, "reaction did not restart when firewall was restarted"

      output = machine.succeed("iptables -w -L -n")
      assert "reaction" in output, "reaction chain missing after firewall restart"

      # Stop reaction manually and verify chains are cleaned up
      machine.succeed("systemctl stop reaction")
      output = machine.succeed("iptables -w -L -n || true")
      assert "reaction" not in output, "reaction chain still exists after stop"

      # Start reaction again and verify it works
      machine.succeed("systemctl start reaction")
      machine.wait_for_unit("reaction.service")

      output = machine.succeed("iptables -w -L -n")
      assert "reaction" in output, "reaction chain not recreated"
    '';

  # Debug interactively with:
  # - nix run .#nixosTests.reaction-firewall.driverInteractive -L
  # - run_tests()
  interactive.sshBackdoor.enable = true; # ssh -o User=root vsock%3

  meta.maintainers =
    with lib.maintainers;
    [
      ppom
      phanirithvij
    ]
    ++ lib.teams.ngi.members;
}
