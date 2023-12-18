{ lib, buildKodiAddon, fetchzip, addonUpdateScript, requests }:

buildKodiAddon rec {
  pname = "radioparadise";
  namespace = "script.radioparadise";
  version = "2.0.0";

  src = fetchzip {
    url = "https://mirrors.kodi.tv/addons/nexus/script.radioparadise/script.radioparadise-${version}.zip";
    sha256 = "sha256-eRCP0XMQHmyDrZ8Y6RGFfxQ1r26/bWbE/PJz4PET7D8=";
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
