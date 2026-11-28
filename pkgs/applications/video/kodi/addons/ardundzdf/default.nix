{
  lib,
  buildKodiAddon,
  fetchFromGitHub,
  addonUpdateScript,
  requests,
  kodi-six,
}:

buildKodiAddon rec {
  pname = "ARDundZDF";
  namespace = "plugin.video.ardundzdf";
  version = "5.5.6";

  src = fetchFromGitHub {
    owner = "rols1";
    repo = "Kodi-Addon-ARDundZDF";
    rev = version;
    hash = "sha256-WPjA0HeFFVtoM9xN7zG11hAk6HVv1S2RD7qITFggODE=";
  };

  propagatedBuildInputs = [
    kodi-six
    requests
  ];

  passthru = {
    updateScript = addonUpdateScript {
      attrPath = "kodi.packages.ardundzdf";
    };
  };

  meta = {
    homepage = "https://github.com/rols1/Kodi-Addon-ARDundZDF";
    description = "Kodi add-on for accessing ARD and ZDF media libraries, live TV, radio and podcasts";
    license = lib.licenses.mit;
    teams = [ lib.teams.kodi ];
  };
}
