{
  lib,
  fetchurl,
}:
let
  generated = builtins.fromJSON (builtins.readFile ./generated.json);
  mkCalibrePlugin =
    pname: plugin':
    let
      plugin = plugin'.info;
    in
    fetchurl {
      inherit pname;
      inherit (plugin) version;

      url = plugin.download_link.link;
      inherit (plugin') hash;

      meta = {
        inherit (plugin) description homepage;
        platforms = lib.concatMap (
          platform:
          if platform == "linux" then
            lib.platforms.linux
          else if platform == "osx" then
            lib.platforms.darwin
          else if platform == "windows" then
            lib.platforms.windows
          else
            throw "Unknown platform for Calibre plugin ${pname}: ${platform}"
        ) plugin.platforms;
        maintainers = [ lib.maintainers.PerchunPak ];
      };
      passthru = {
        plugin-meta = plugin';
        file-name = plugin.download_link.file_name;
      };
    };
in
lib.mapAttrs mkCalibrePlugin generated
