{ stdenvNoCC, mpv-unwrapped, lib }:

stdenvNoCC.mkDerivation rec {
  pname = "mpv-autoload";
  version = mpv-unwrapped.version;
  src = "${mpv-unwrapped.src.outPath}/TOOLS/lua/autoload.lua";
  dontBuild = true;
  dontUnpack = true;
  installPhase = ''
    install -Dm644 ${src} $out/share/mpv/scripts/autoload.lua
  '';
  passthru.scriptName = "autoload.lua";

  meta = {
    description = "This script automatically loads playlist entries before and after the currently played file";
    homepage = "https://github.com/mpv-player/mpv/blob/master/TOOLS/lua/autoload.lua";
    maintainers = [ lib.maintainers.dawidsowa ];
    license = lib.licenses.gpl2Plus;
  };
}
