{ lib, buildKodiAddon, fetchzip, addonUpdateScript }:
buildKodiAddon rec {
  pname = "chardet";
  namespace = "script.module.chardet";
  version = "4.0.0+matrix.1";

  src = fetchzip {
    url = "https://mirrors.kodi.tv/addons/matrix/${namespace}/${namespace}-${version}.zip";
    sha256 = "1jsd165mb1b8jdan2jbjd3y3xa0xam2cxcccmwazkybpa0r6a7dj";
  };

  passthru = {
    pythonPath = "lib";
    updateScript = addonUpdateScript {
      attrPath = "kodi.packages.chardet";
    };
  };

  meta = with lib; {
    homepage = "https://github.com/Freso/script.module.chardet";
    description = "Universal encoding detector";
    license = licenses.lgpl2Only;
    maintainers = teams.kodi.members;
  };
}
