{ lib, buildKodiAddon, fetchzip, addonUpdateScript }:
buildKodiAddon rec {
  pname = "typing_extensions";
  namespace = "script.module.typing_extensions";
  version = "3.7.4.3";

  src = fetchzip {
    url = "https://mirrors.kodi.tv/addons/matrix/${namespace}/${namespace}-${version}.zip";
    sha256 = "0p28hchj05hmccs6b2836kh4vqdqnl169409f2845d0nw9y4wkqq";
  };

  passthru = {
    pythonPath = "lib";
    updateScript = addonUpdateScript {
      attrPath = "kodi.packages.typing_extensions";
    };
  };

  meta = with lib; {
    homepage = "https://github.com/python/typing/tree/master/typing_extensions";
    description = "Python typing extensions";
    license = licenses.psfl;
    maintainers = teams.kodi.members;
  };
}
