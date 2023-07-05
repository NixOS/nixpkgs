{ stdenvNoCC, mpv-unwrapped, lib }:

stdenvNoCC.mkDerivation rec {
  pname = "mpv-autocrop";
  version = mpv-unwrapped.version;
  src = "${mpv-unwrapped.src.outPath}/TOOLS/lua/autocrop.lua";
  dontBuild = true;
  dontUnpack = true;
  installPhase = ''
    install -Dm644 ${src} $out/share/mpv/scripts/autocrop.lua
  '';
  passthru.scriptName = "autocrop.lua";

  meta = {
    description = "This script uses the lavfi cropdetect filter to automatically insert a crop filter with appropriate parameters for the currently playing video.";
    homepage = "https://github.com/mpv-player/mpv/blob/master/TOOLS/lua/autocrop.lua";
    license = lib.licenses.gpl2Plus;
  };
}
