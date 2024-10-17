import ./make-test-python.nix ({ pkgs, lib, ... }:
{
  name = "netbird";

  meta.maintainers = with pkgs.lib.maintainers; [ ];

  nodes = {
    node = { ... }: {
      services.netbird.enable = true;
    };
  };

  # TODO: confirm the whole solution is working end-to-end when netbird server is implemented
  testScript = ''
    start_all()
    node.wait_for_unit("netbird.service")
    node.wait_for_file("/var/run/netbird/sock")
    output = node.succeed("netbird status")
    # used to print `Daemon status: NeedsLogin`, but not anymore `Management: Disconnected`
    assert "Disconnected" in output or "NeedsLogin" in output
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
})
