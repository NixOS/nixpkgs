import ./make-test-python.nix {
  name = "mediatomb";

  nodes = {
    server = {
      services.mediatomb = {
        enable = true;
        serverName = "Gerbera";
        interface = "eth1";
        openFirewall = true;
        mediaDirectories = [
          {
            path = "/var/lib/gerbera/pictures";
            recursive = false;
            hidden-files = false;
          }
          {
            path = "/var/lib/gerbera/audio";
            recursive = true;
            hidden-files = false;
          }
        ];
      };
      systemd.tmpfiles.rules = [
        "d /var/lib/gerbera/pictures 0770 mediatomb mediatomb"
        "d /var/lib/gerbera/audio 0770 mediatomb mediatomb"
      ];
    };

    client = { };
  };

  testScript =
    { nodes, ... }:
    let
      serverIP = nodes.server.networking.primaryIPAddress;
      serverIPv6 = nodes.server.networking.primaryIPv6Address;
    in
    ''
      start_all()

      server.wait_for_unit("mediatomb")
      server.wait_until_succeeds("nc -z ${serverIP} 49152")
      server.succeed("curl -v --fail http://${serverIP}:49152/")
      server.succeed("curl -v --fail http://[${serverIPv6}]:49152/")

      client.wait_for_unit("multi-user.target")
      page = client.succeed("curl -v --fail http://${serverIP}:49152/")
      page = client.succeed("curl -v --fail http://[${serverIPv6}]:49152/")
      assert "Gerbera" in page and "MediaTomb" not in page
    '';
}
