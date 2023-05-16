{ lib, buildKodiAddon, fetchzip, addonUpdateScript }:
buildKodiAddon rec {
  pname = "chardet";
  namespace = "script.module.chardet";
<<<<<<< HEAD
  version = "5.1.0";

  src = fetchzip {
    url = "https://mirrors.kodi.tv/addons/nexus/${namespace}/${namespace}-${version}.zip";
    sha256 = "sha256-cIQIX6LVAoGf1sBRKWonXJd3XYqGOa5WIUttabV0HeU=";
=======
  version = "4.0.0+matrix.1";

  src = fetchzip {
    url = "https://mirrors.kodi.tv/addons/nexus/${namespace}/${namespace}-${version}.zip";
    sha256 = "sha256-sh1lMlB3+fkVr4yxzkRVHag+/GhySWFVk2iFVYsJTcs=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
