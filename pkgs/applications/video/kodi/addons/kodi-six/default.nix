{ lib, buildKodiAddon, fetchzip, addonUpdateScript }:

buildKodiAddon rec {
  pname = "kodi-six";
  namespace = "script.module.kodi-six";
  version = "0.1.3.1";

  src = fetchzip {
    url = "https://mirrors.kodi.tv/addons/matrix/${namespace}/${namespace}-${version}.zip";
    sha256 = "14m232p9hx925pbk8knsg994m1nbpa5278zmcrnfblh4z84gjv4x";
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
