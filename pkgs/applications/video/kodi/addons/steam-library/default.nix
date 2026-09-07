{
  lib,
  buildKodiAddon,
  fetchFromGitHub,
  requests,
  requests-cache,
  routing,
}:

buildKodiAddon rec {
  pname = "steam-library";
  namespace = "plugin.program.steam.library";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "aanderse";
    repo = namespace;
    rev = "v${version}";
    sha256 = "sha256-HwPNBqD+zS5sDNXtiGEmoc1RJ1SFCRzVOzUCjunMCnU=";
  };

  propagatedBuildInputs = [
    requests
    requests-cache
    routing
  ];

  meta = {
    homepage = "https://github.com/aanderse/plugin.program.steam.library";
    description = "View your entire Steam library right from Kodi";
    license = lib.licenses.gpl3Plus;
    teams = [ lib.teams.kodi ];
  };
}
