{
  lib,
  buildLua,
  fetchFromGitHub,
}:
buildLua (finalAttrs: {
  pname = "mpv-osc-tethys";
  version = "0-unstable-2024-08-19";

  scriptPath = "osc_tethys.lua";
  extraScripts = [ "mpv_thumbnail_script_server.lua" ];

  src = fetchFromGitHub {
    owner = "Zren";
    repo = "mpv-osc-tethys";
    rev = "c4167f88a0e9944738419e90a71f1f80fba39ccb";
    hash = "sha256-eAY+ZUuOxPJiNCuL7lqMBU4iURCMz12LQdfaYj4WFQc=";
  };

  meta = with lib; {
    description = "OSC UI replacement for MPV with icons from the bomi video player";
    homepage = "https://github.com/Zren/mpv-osc-tethys";
    license = licenses.unfree; # no license specified
    maintainers = with maintainers; [ luftmensch-luftmensch ];
  };
})
