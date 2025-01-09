import ./make-test-python.nix (
  { pkgs, lib, ... }:
  {
    name = "netbird";

    meta.maintainers = with pkgs.lib.maintainers; [
      nazarewk
    ];

    nodes = {
      clients =
        { ... }:
        {
          services.netbird.enable = true;
          services.netbird.clients.custom.port = 51819;
        };
    };

    # TODO: confirm the whole solution is working end-to-end when netbird server is implemented
    testScript = ''
      start_all()
      def did_start(node, name):
        node.wait_for_unit(f"{name}.service")
        node.wait_for_file(f"/var/run/{name}/sock")
        output = node.succeed(f"{name} status")

        # not sure why, but it can print either of:
        #  - Daemon status: NeedsLogin
        #  - Management: Disconnected
        expected = [
          "Disconnected",
          "NeedsLogin",
        ]
        assert any(msg in output for msg in expected)

      did_start(clients, "netbird")
      did_start(clients, "netbird-custom")
    '';

    /*
      `netbird status` used to print `Daemon status: NeedsLogin`
          https://github.com/netbirdio/netbird/blob/23a14737974e3849fa86408d136cc46db8a885d0/client/cmd/status.go#L154-L164
      as the first line, but now it is just:

          Daemon version: 0.26.3
          CLI version: 0.26.3
          Management: Disconnected
          Signal: Disconnected
          Relays: 0/0 Available
          Nameservers: 0/0 Available
          FQDN:
          NetBird IP: N/A
          Interface type: N/A
          Quantum resistance: false
          Routes: -
          Peers count: 0/0 Connected
    */
  }
)
