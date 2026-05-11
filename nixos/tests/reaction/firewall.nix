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
        settings = {
          # In the qemu vm `run0 ls` as root prints nothing, so we can't use it
          # see https://reaction.ppom.me/reference.html#systemd
          plugins.ipset.systemd = false;
          plugins.virtual.systemd = false;
        };
      };
      networking.firewall.enable = true;
    };

  testScript = # py
    ''
      start_all()

      machine.wait_for_unit("multi-user.target")
      machine.wait_for_unit("firewall.service")
      machine.wait_for_unit("reaction.service")

      def check_reaction_in_iptables(context = ""):
        with subtest("check reaction chain exists"):
          machine.sleep(3)
          output = machine.succeed("iptables -nvL")
          assert "reaction" in output, f"error: reaction chain missing in iptables, {context}"

      check_reaction_in_iptables()

      with subtest("reload firewall"):
        machine.succeed("systemctl reload firewall")
        output = machine.succeed("journalctl -u firewall.service --no-pager")
        assert "ERROR" not in output, "firewall reload failed due to reaction"

        check_reaction_in_iptables(context="after firewall reload")

      with subtest("restart firewall"):
        machine.succeed("systemctl restart firewall")
        output = machine.succeed("journalctl -u reaction.service --no-pager")
        assert "INFO stop command" in output and "INFO start command" in output, "reaction did not restart when firewall was restarted"

        check_reaction_in_iptables(context="after firewall restart")

      with subtest("stop reaction manually and verify chains are cleaned up"):
        machine.succeed("systemctl stop reaction")
        machine.sleep(3)
        output = machine.succeed("iptables -nvL")
        assert "reaction" not in output, "reaction chain still exists after the service was stopped"

        with subtest("start reaction again and verify it works"):
          machine.succeed("systemctl start reaction")
          machine.wait_for_unit("reaction.service")

          check_reaction_in_iptables()
    '';

  # Debug interactively with:
  # - nix run .#nixosTests.reaction-firewall.driverInteractive -L
  # - run_tests()
  interactive.sshBackdoor.enable = true; # ssh -o User=root vsock%3
  interactive.nodes.machine = _: {
    virtualisation.graphics = false;
  };

  meta.maintainers =
    with lib.maintainers;
    [
      ppom
    ]
    ++ lib.teams.ngi.members;
}
