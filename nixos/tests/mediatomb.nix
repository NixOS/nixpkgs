import ./make-test-python.nix ({ pkgs, ... }:

{
  name = "mediatomb";

  nodes = {
    serverGerbera =
      { ... }:
      let port = 49152;
      in {
        imports = [ ../modules/profiles/minimal.nix ];
        services.mediatomb = {
          enable = true;
          serverName = "Gerbera";
          package = pkgs.gerbera;
          interface = "eth1";  # accessible from test
          openFirewall = true;
          mediaDirectories = [
            { path = "/var/lib/gerbera/pictures"; recursive = false; hidden-files = false; }
            { path = "/var/lib/gerbera/audio"; recursive = true; hidden-files = false; }
          ];
        };
      };

    serverMediatomb =
      { ... }:
      let port = 49151;
      in {
        imports = [ ../modules/profiles/minimal.nix ];
        services.mediatomb = {
          enable = true;
          serverName = "Mediatomb";
          package = pkgs.mediatomb;
          interface = "eth1";
          inherit port;
          mediaDirectories = [
            { path = "/var/lib/mediatomb/pictures"; recursive = false; hidden-files = false; }
            { path = "/var/lib/mediatomb/audio"; recursive = true; hidden-files = false; }
          ];
        };
        networking.firewall.interfaces.eth1 = {
          allowedUDPPorts = [ 1900 port ];
          allowedTCPPorts = [ port ];
        };
      };

      client = { ... }: { };
  };

  testScript =
  ''
    start_all()

    port = 49151
    serverMediatomb.succeed("mkdir -p /var/lib/mediatomb/{pictures,audio}")
    serverMediatomb.succeed("chown -R mediatomb:mediatomb /var/lib/mediatomb")
    serverMediatomb.wait_for_unit("mediatomb")
    serverMediatomb.wait_for_open_port(port)
    serverMediatomb.succeed(f"curl --fail http://serverMediatomb:{port}/")
    page = client.succeed(f"curl --fail http://serverMediatomb:{port}/")
    assert "MediaTomb" in page and "Gerbera" not in page
    serverMediatomb.shutdown()

    port = 49152
    serverGerbera.succeed("mkdir -p /var/lib/mediatomb/{pictures,audio}")
    serverGerbera.succeed("chown -R mediatomb:mediatomb /var/lib/mediatomb")
    # service running gerbera fails the first time claiming something is already bound
    # gerbera[715]: 2020-07-18 23:52:14   info: Please check if another instance of Gerbera or
    # gerbera[715]: 2020-07-18 23:52:14   info: another application is running on port TCP 49152 or UDP 1900.
    # I did not find anything so here I work around this
    serverGerbera.succeed("sleep 2")
    serverGerbera.wait_until_succeeds("systemctl restart mediatomb")
    serverGerbera.wait_for_unit("mediatomb")
    serverGerbera.succeed(f"curl --fail http://serverGerbera:{port}/")
    page = client.succeed(f"curl --fail http://serverGerbera:{port}/")
    assert "Gerbera" in page and "MediaTomb" not in page

    serverGerbera.shutdown()
    client.shutdown()
  '';
})
