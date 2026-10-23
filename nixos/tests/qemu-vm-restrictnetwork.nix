import ./make-test-python.nix {
  name = "qemu-vm-restrictnetwork";

  nodes = {
    unrestricted =
      { config, pkgs, ... }:
      {
        virtualisation.restrictNetwork = false;
      };

    restricted =
      { config, pkgs, ... }:
      {
        virtualisation.restrictNetwork = true;
      };
  };

  testScript = ''
    import os

    if os.fork() == 0:
      # Start some HTTP server on the qemu host to test guest isolation.
      from http.server import HTTPServer, BaseHTTPRequestHandler
      HTTPServer(("", 8000), BaseHTTPRequestHandler).serve_forever()

    else:
      start_all()
      unrestricted.systemctl("start network-online.target")
      restricted.systemctl("start network-online.target")
      unrestricted.wait_for_unit("network-online.target")
      restricted.wait_for_unit("network-online.target")

      # Guests should be able to reach each other on the same VLAN.
      unrestricted.succeed("ping -c1 restricted")
      restricted.succeed("ping -c1 unrestricted")

      # Only the unrestricted guest should be able to reach host services.
      # 10.0.2.2 is the gateway mapping to the host's loopback interface.
      unrestricted.succeed("curl -s http://10.0.2.2:8000")
      restricted.fail("curl -s http://10.0.2.2:8000")
  '';
}
