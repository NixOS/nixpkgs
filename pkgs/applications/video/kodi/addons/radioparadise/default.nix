{ lib, buildKodiAddon, fetchzip, addonUpdateScript, requests }:

buildKodiAddon rec {
  pname = "radioparadise";
  namespace = "script.radioparadise";
  version = "1.0.5";

  src = fetchzip {
    url = "https://mirrors.kodi.tv/addons/nexus/script.radioparadise/script.radioparadise-${version}.zip";
    sha256 = "sha256-/X/8Q741piNHue5i/kgV+UYpBECyGzkFuN+PUzdeQnA=";
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
