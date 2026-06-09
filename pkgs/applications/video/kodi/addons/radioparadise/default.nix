{
  lib,
  rel,
  buildKodiAddon,
  fetchzip,
  addonUpdateScript,
  requests,
}:

buildKodiAddon rec {
  pname = "radioparadise";
  namespace = "script.radioparadise";
  version = "2.4.0";

  src = fetchzip {
    url = "https://mirrors.kodi.tv/addons/${lib.toLower rel}/script.radioparadise/script.radioparadise-${version}.zip";
    sha256 = "sha256-qM+YzWesgAIiqL2YbKgJ0wSTTghtPPBcMGzsKF7tVAY=";
  };

  propagatedBuildInputs = [
    requests
  ];

  passthru = {
    pythonPath = "resources/lib";
    updateScript = addonUpdateScript {
      attrPath = "kodi.packages.radioparadise";
    };
  };

  meta = {
    homepage = "https://github.com/alxndr42/script.radioparadise";
    description = "Radio Paradise addon for Kodi";
    license = lib.licenses.gpl3Plus;
    teams = [ lib.teams.kodi ];
  };
}
