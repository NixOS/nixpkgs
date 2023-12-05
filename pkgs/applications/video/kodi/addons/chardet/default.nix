{ lib, buildKodiAddon, fetchzip, addonUpdateScript }:
buildKodiAddon rec {
  pname = "chardet";
  namespace = "script.module.chardet";
  version = "5.1.0";

  src = fetchzip {
    url = "https://mirrors.kodi.tv/addons/nexus/${namespace}/${namespace}-${version}.zip";
    sha256 = "sha256-cIQIX6LVAoGf1sBRKWonXJd3XYqGOa5WIUttabV0HeU=";
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
