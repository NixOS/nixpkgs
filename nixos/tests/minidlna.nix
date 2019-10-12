import ./make-test.nix ({ pkgs, ... }: {
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
    startAll;
    $server->succeed("mkdir -p /tmp/stuff && chown minidlna: /tmp/stuff");
    $server->waitForUnit("minidlna");
    $server->waitForOpenPort("8200");
    $server->succeed("curl --fail http://localhost:8200/");
    $client->succeed("curl --fail http://server:8200/");
  '';
})
