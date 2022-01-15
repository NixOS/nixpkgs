{ lib, buildKodiAddon, fetchFromGitHub, requests, requests-cache, routing }:

buildKodiAddon rec {
  pname = "steam-library";
  namespace = "plugin.program.steam.library";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "aanderse";
    repo = namespace;
    rev = "v${version}";
    sha256 = "1ai8k55bamzkx7awk3dl8ksw93pan3h9b1xlylcldy7a0ddldzdg";
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
