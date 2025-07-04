{ pkgs, ... }:
{
  name = "minidlna";

  nodes = {
    server =
      { ... }:
      {
        imports = [ ../modules/profiles/minimal.nix ];
        services.minidlna.enable = true;
        services.minidlna.openFirewall = true;
        services.minidlna.settings = {
          log_level = "error";
          media_dir = [
            "PV,/tmp/stuff"
          ];
          friendly_name = "rpi3";
          root_container = "B";
          notify_interval = 60;
          album_art_names = [
            "Cover.jpg/cover.jpg/AlbumArtSmall.jpg/albumartsmall.jpg"
            "AlbumArt.jpg/albumart.jpg/Album.jpg/album.jpg"
            "Folder.jpg/folder.jpg/Thumb.jpg/thumb.jpg"
          ];
        };
      };
    client = { ... }: { };
  };

  testScript = ''
    start_all()
    server.succeed("mkdir -p /tmp/stuff && chown minidlna: /tmp/stuff")
    server.wait_for_unit("minidlna")
    server.wait_for_open_port(8200)
    # requests must be made *by IP* to avoid triggering minidlna's
    # DNS-rebinding protection
    server.succeed("curl --fail http://$(getent ahostsv4 localhost | head -n1 | cut -f 1 -d ' '):8200/")
    client.succeed("curl --fail http://$(getent ahostsv4 server | head -n1 | cut -f 1 -d ' '):8200/")
  '';
}
