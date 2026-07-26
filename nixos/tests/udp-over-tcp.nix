{ lib, ... }:
{
  name = "udp-over-tcp";
  meta.maintainers = [ lib.maintainers.timschumi ];

  nodes.sender =
    { nodes, ... }:
    {
      services.udp-over-tcp = {
        udp2tcp = {
          "0.0.0.0:51821" = {
            forward = "${nodes.receiver.networking.primaryIPAddress}:444";
            openFirewall = true;

            # Remaining options are not tested for behavior, but to cover options passing.
            recvBufferSize = 16384;
            sendBufferSize = 16384;
            recvTimeout = 10;
            fwmark = 1337;
            nodelay = true;
          };
        };
      };
    };

  nodes.receiver =
    { nodes, ... }:
    {
      services.udp-over-tcp = {
        tcp2udp = {
          "0.0.0.0:444" = {
            forward = "127.0.0.1:51821";
            openFirewall = true;

            # Remaining options are not tested for behavior, but to cover options passing.
            threads = 2;
            bind = "127.0.0.1";
            recvBufferSize = 16384;
            sendBufferSize = 16384;
            recvTimeout = 10;
            fwmark = 1337;
            nodelay = true;
          };
        };
      };
    };

  testScript = ''
    start_all()

    # TODO: Replace unit wait with waiting on an UDP port.
    sender.wait_for_unit("udp2tcp-0.0.0.0:51821.service")
    receiver.wait_for_open_port(444, "0.0.0.0")

    receiver.succeed("nc -w 10 -u -l 127.0.0.1 51821 > transfer.txt &")
    # We need to delay a short time here because detaching exits the shell before the socket is ready.
    receiver.execute("sleep 1")
    sender.succeed("echo 'Hello World!' | nc -w 1 -u 127.0.0.1 51821")
    receiver.succeed("grep 'Hello World!' transfer.txt")
  '';
}
