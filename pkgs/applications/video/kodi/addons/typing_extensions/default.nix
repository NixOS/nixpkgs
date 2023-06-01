{ lib, buildKodiAddon, fetchzip, addonUpdateScript }:
buildKodiAddon rec {
  pname = "typing_extensions";
  namespace = "script.module.typing_extensions";
  version = "3.7.4.3";

  src = fetchzip {
    url = "https://mirrors.kodi.tv/addons/nexus/${namespace}/${namespace}-${version}.zip";
    sha256 = "sha256-GE9OfOIWtEKQcAmQZAK1uOFN4DQDiWU0YxUWICGDSFw=";
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
