import ./make-test-python.nix ({ pkgs, lib, ...} :

let
  chipVersion = pkgs.python311Packages.home-assistant-chip-core.version;
in

{
  name = "matter-server";
  meta.maintainers = with lib.maintainers; [ leonm1 ];

  nodes = {
    machine = { config, ... }: {
      services.matter-server = {
        enable = true;
        port = 1234;
      };
    };
  };

  testScript = /* python */ ''
    start_all()

    machine.wait_for_unit("matter-server.service")
    machine.wait_for_open_port(1234)

    with subtest("Check websocket server initialized"):
        output = machine.succeed("echo \"\" | ${pkgs.websocat}/bin/websocat ws://localhost:1234/ws")
        machine.log(output)

    assert '"sdk_version": "${chipVersion}"' in output, (
      'CHIP version \"${chipVersion}\" not present in websocket message'
    )

    assert '"fabric_id": 1' in output, (
      "fabric_id not propagated to server"
    )

    with subtest("Check storage directory is created"):
        machine.succeed("ls /var/lib/matter-server/chip.json")

    with subtest("Check systemd hardening"):
        _, output = machine.execute("systemd-analyze security matter-server.service | grep -v '✓'")
        machine.log(output)
  '';
})
