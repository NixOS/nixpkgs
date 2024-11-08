{
  lib,
  buildLua,
  mpv-unwrapped,
}:

let
  mkBuiltin =
    name: args:
    let
      srcPath = "TOOLS/lua/${name}.lua";
    in
    buildLua (
      lib.attrsets.recursiveUpdate rec {
        inherit (mpv-unwrapped) src version;
        pname = "mpv-${name}";

        dontUnpack = true;
        scriptPath = "${src}/${srcPath}";

        meta = with lib; {
          inherit (mpv-unwrapped.meta) license;
          homepage = "https://github.com/mpv-player/mpv/blob/v${version}/${srcPath}";
        };
      } args
    );
in
lib.mapAttrs (name: lib.makeOverridable (mkBuiltin name)) {
  acompressor.meta = {
    description = "Script to toggle and control ffmpeg's dynamic range compression filter";
    maintainers = with lib.maintainers; [ nicoo ];
  };

  autocrop.meta.description = "This script uses the lavfi cropdetect filter to automatically insert a crop filter with appropriate parameters for the currently playing video";

  autodeint.meta.description = "This script uses the lavfi idet filter to automatically insert the appropriate deinterlacing filter based on a short section of the currently playing video";

  autoload.meta = {
    description = "This script automatically loads playlist entries before and after the currently played file";
    maintainers = [ lib.maintainers.dawidsowa ];
  };
}
