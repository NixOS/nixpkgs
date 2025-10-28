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
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "aanderse";
    repo = namespace;
    rev = "v${version}";
    sha256 = "sha256-LVdFih0n/lkjyaYf8jw0IFlcDiXXOtUH2N9OduV1H9Q=";
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
    teams = [ teams.kodi ];
  };
}
