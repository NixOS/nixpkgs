{ lib
, buildLua
, mpv-unwrapped
}:

buildLua {
  inherit (mpv-unwrapped) src version;
  pname = "mpv-acompressor";
  scriptPath = "TOOLS/lua/acompressor.lua";

  meta = with lib; {
    inherit (mpv-unwrapped.meta) license;
    description = "Script to toggle and control ffmpeg's dynamic range compression filter.";
    homepage = "https://github.com/mpv-player/mpv/blob/master/TOOLS/lua/acompressor.lua";
    maintainers = with maintainers; [ nicoo ];
  };
}
