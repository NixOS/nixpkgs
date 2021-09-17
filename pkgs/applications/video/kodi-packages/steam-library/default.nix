{ lib, buildKodiAddon, fetchFromGitHub, requests, requests-cache, routing }:

buildKodiAddon rec {
  pname = "steam-library";
  namespace = "plugin.program.steam.library";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "aanderse";
    repo = namespace;
    rev = "v${version}";
    sha256 = "1d8n8zkprjql0nw5ff752yr994hw2ikd0ny3m9hjr90s4kdykjzr";
  };

  propagatedBuildInputs = [
    requests
    requests-cache
    routing
  ];

  meta = with lib; {
    homepage = "https://github.com/aanderse/plugin.program.steam.library";
    description = "View your entire Steam library right from Kodi";
    license = licenses.gpl3Plus;
    maintainers = teams.kodi.members;
  };
}
