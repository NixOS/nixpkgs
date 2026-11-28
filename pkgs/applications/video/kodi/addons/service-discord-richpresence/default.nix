{
  lib,
  buildKodiAddon,
  fetchzip,
}:

buildKodiAddon rec {
  pname = "service-discord-richpresence";
  version = "1.7.8";
  namespace = "service.discord.richpresence";

  src = fetchzip {
    url = "https://github.com/Hiumee/service.discord.richpresence/releases/download/v${version}/service.discord.richpresence-${version}.zip";
    sha256 = "sha256-rzJ3DG3055D0iE7dtswCTSP6sNCLsI7yqDIk2/evzgE=";
  };

  meta = with lib; {
    description = "Displays what you are watching with Kodi on Discord using Rich Presence";
    homepage = "https://github.com/Hiumee/service.discord.richpresence";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ _2hexed ];
  };
}
