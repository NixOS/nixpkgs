{ stdenvNoCC, mpv-unwrapped, lib }:

stdenvNoCC.mkDerivation rec {
  pname = "mpv-autodeint";
  version = mpv-unwrapped.version;
  src = "${mpv-unwrapped.src.outPath}/TOOLS/lua/autodeint.lua";
  dontBuild = true;
  dontUnpack = true;
  installPhase = ''
    install -Dm644 ${src} $out/share/mpv/scripts/autodeint.lua
  '';
  passthru.scriptName = "autodeint.lua";

  meta = {
    description = "This script uses the lavfi idet filter to automatically insert the appropriate deinterlacing filter based on a short section of the currently playing video.";
    homepage = "https://github.com/mpv-player/mpv/blob/master/TOOLS/lua/autodeint.lua";
    license = lib.licenses.gpl2Plus;
  };
}
