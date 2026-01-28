{
  lib,
  stdenv,
  fetchzip,
}:
let
  generated = builtins.fromJSON (builtins.readFile ./generated.json);
  mkCalibrePlugin =
    pname: plugin:
    stdenv.mkDerivation {
      inherit pname;
      inherit (plugin) version;

      src = fetchzip {
        inherit (plugin.src) name url hash;
        stripRoot = false;
      };

      buildPhase = ''
        cp -r $src $out
      '';

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
    };
in
lib.mapAttrs mkCalibrePlugin generated
