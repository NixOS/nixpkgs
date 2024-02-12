{ lib, buildKodiAddon, fetchzip, addonUpdateScript }:

buildKodiAddon rec {
  pname = "kodi-six";
  namespace = "script.module.kodi-six";
  version = "0.1.3.1";

  src = fetchzip {
    url = "https://mirrors.kodi.tv/addons/nexus/${namespace}/${namespace}-${version}.zip";
    sha256 = "sha256-nWz5CPoE0uVsZvWjI4q6y4ZKUnraTjTXLSJ1mK4YopI=";
  };

  passthru = {
    pythonPath = "libs";
    updateScript = addonUpdateScript {
      attrPath = "kodi.packages.kodi-six";
    };
  };

  meta = with lib; {
    homepage = "https://github.com/romanvm/kodi.six";
    description = "Wrappers around Kodi Python API for seamless Python 2/3 compatibility";
    license = licenses.gpl3Only;
    maintainers = teams.kodi.members;
  };
}
