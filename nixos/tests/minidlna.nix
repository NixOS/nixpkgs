import ./make-test-python.nix ({ pkgs, ... }: {
  name = "minidlna";

  nodes = {
    server =
      { ... }:
      {
        imports = [ ../modules/profiles/minimal.nix ];
        networking.firewall.allowedTCPPorts = [ 8200 ];
        services.minidlna = {
          enable = true;
          loglevel = "error";
          mediaDirs = [
           "PV,/tmp/stuff"
          ];
          friendlyName = "rpi3";
          rootContainer = "B";
          extraConfig =
          ''
            album_art_names=Cover.jpg/cover.jpg/AlbumArtSmall.jpg/albumartsmall.jpg
            album_art_names=AlbumArt.jpg/albumart.jpg/Album.jpg/album.jpg
            album_art_names=Folder.jpg/folder.jpg/Thumb.jpg/thumb.jpg
            notify_interval=60
          '';
        };
      };
      client = { ... }: { };
  };

  testScript =
  ''
    start_all()
    server.succeed("mkdir -p /tmp/stuff && chown minidlna: /tmp/stuff")
    server.wait_for_unit("minidlna")
    server.wait_for_open_port("8200")
    # requests must be made *by IP* to avoid triggering minidlna's
    # DNS-rebinding protection
    server.succeed("curl --fail http://$(getent ahostsv4 localhost | head -n1 | cut -f 1 -d ' '):8200/")
    client.succeed("curl --fail http://$(getent ahostsv4 server | head -n1 | cut -f 1 -d ' '):8200/")
  '';
})
