{ lib, rel, buildKodiAddon, fetchzip, addonUpdateScript, requests }:

buildKodiAddon rec {
  pname = "radioparadise";
  namespace = "script.radioparadise";
  version = "2.1.2";

  src = fetchzip {
    url = "https://mirrors.kodi.tv/addons/${lib.toLower rel}/script.radioparadise/script.radioparadise-${version}.zip";
    sha256 = "sha256-bzUfP1n/6FF42rH8NvkU6LBLKmY6IyF5ddpC/0jbK1U=";
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
