{ pkgs, lib, ... }:

let
  chipVersion = pkgs.python311Packages.home-assistant-chip-core.version;
in

{
  name = "matter-server";
  meta.maintainers = with lib.maintainers; [ leonm1 ];
  meta.timeout = 120; # Timeout after two minutes

  nodes = {
    machine =
      { config, ... }:
      {
        services.matter-server = {
          enable = true;
          port = 1234;
          openFirewall = true;
        };
      };
  };

  testScript = # python
    ''
      @polling_condition
      def matter_server_running():
        machine.succeed("systemctl status matter-server")

      start_all()

      machine.wait_for_unit("matter-server.service", timeout=20)
      machine.wait_for_open_port(1234, timeout=20)

      with matter_server_running: # type: ignore[union-attr]
        with subtest("Check websocket server initialized"):
            output = machine.succeed("echo \"\" | ${pkgs.websocat}/bin/websocat ws://localhost:1234/ws")
            machine.log(output)

        assert '"fabric_id": 1' in output, (
          "fabric_id not propagated to server"
        )

        with subtest("Check storage directory is created"):
            machine.succeed("ls /var/lib/matter-server/chip.json")

        with subtest("Check dashboard loads"):
            machine.succeed("curl -f 127.0.0.1:1234")

        with subtest("Check systemd hardening"):
            _, output = machine.execute("systemd-analyze security matter-server.service | grep -v '✓'")
            machine.log(output)
    '';
}
