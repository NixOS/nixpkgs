{ lib, ... }:
{
  name = "magic-wormhole-mailbox-server";
  meta.maintainers = [ lib.maintainers.mmahut ];

  nodes = {
    server = {
      networking.firewall.allowedTCPPorts = [ 4000 ];
      services.magic-wormhole-mailbox-server.enable = true;
    };
    client_alice =
      { pkgs, ... }:
      {
        networking.firewall.enable = false;
        environment.systemPackages = [ pkgs.magic-wormhole ];
      };
    client_bob =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.magic-wormhole ];
      };
  };

  testScript = ''
    start_all()

    # Start the wormhole relay server
    server.wait_for_unit("magic-wormhole-mailbox-server.service")
    server.wait_for_open_port(4000)

    # Create a secret file and send it to Bob
    client_alice.succeed("echo mysecret > secretfile")
    client_alice.succeed("wormhole --relay-url=ws://server:4000/v1 send -0 secretfile >&2 &")

    # Retrieve a secret file from Alice and check its content
    client_bob.succeed("wormhole --relay-url=ws://server:4000/v1 receive -0 --accept-file")
    client_bob.succeed("grep mysecret secretfile")
  '';
}
