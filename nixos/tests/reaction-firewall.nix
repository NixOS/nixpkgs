{
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
        stopForFirewall = true; # with this enabled
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

      # Reload firewall and verify reaction stops/starts
      machine.succeed("systemctl reload firewall")
      machine.wait_for_unit("reaction.service")

      # Verify reaction chain still exists after reload
      output = machine.succeed("iptables -w -L -n")
      assert "reaction" in output, "reaction chain missing after firewall reload"

      # Check journalctl for errors
      output = machine.succeed("journalctl -u reaction.service -u firewall.service --no-pager")
      assert "Failed" not in output or "failed" not in output.lower(), "Found failures in logs"

      # Restart firewall (more aggressive than reload)
      machine.succeed("systemctl restart firewall")
      machine.wait_for_unit("reaction.service")
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
}
