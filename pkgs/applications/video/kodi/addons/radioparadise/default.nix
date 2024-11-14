{ lib, rel, buildKodiAddon, fetchzip, addonUpdateScript, requests }:

buildKodiAddon rec {
  pname = "radioparadise";
  namespace = "script.radioparadise";
  version = "2.0.1";

  src = fetchzip {
    url = "https://mirrors.kodi.tv/addons/${lib.toLower rel}/script.radioparadise/script.radioparadise-${version}.zip";
    sha256 = "sha256-osQoOFr1vyTgZdlq1gNmhhDY37e+4SFqN3uX3yT8NQE=";
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

  meta = with lib; {
    homepage = "https://github.com/alxndr42/script.radioparadise";
    description = "Radio Paradise addon for Kodi";
    license = licenses.gpl3Plus;
    maintainers = teams.kodi.members;
  };
}
