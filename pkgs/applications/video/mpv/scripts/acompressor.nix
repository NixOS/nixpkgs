{ stdenvNoCC
, mpv-unwrapped
, lib
}:

stdenvNoCC.mkDerivation rec {
  pname = "mpv-acompressor";
  version = mpv-unwrapped.version;

  src = "${mpv-unwrapped.src.outPath}/TOOLS/lua/acompressor.lua";

  dontBuild = true;
  dontUnpack = true;

  installPhase = ''
    install -Dm644 ${src} $out/share/mpv/scripts/acompressor.lua
  '';

  passthru.scriptName = "acompressor.lua";

  meta = with lib; {
    description = "Script to toggle and control ffmpeg's dynamic range compression filter.";
    homepage = "https://github.com/mpv-player/mpv/blob/master/TOOLS/lua/acompressor.lua";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ nicoo ];
  };
}
