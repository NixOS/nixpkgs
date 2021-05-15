{ lib, buildKodiAddon, fetchzip, addonUpdateScript }:

buildKodiAddon rec {
  pname = "six";
  namespace = "script.module.six";
  version = "1.14.0+matrix.2";

  src = fetchzip {
    url = "https://mirrors.kodi.tv/addons/matrix/${namespace}/${namespace}-${version}.zip";
    sha256 = "1f9g43j4y5x7b1bgbwqqfj0p2bkqjpycj17dj7a9j271mcr5zhwb";
  };

  passthru.updateScript = addonUpdateScript {
    attrPath = "kodi.packages.six";
  };

  meta = with lib; {
    homepage = "https://pypi.org/project/six/";
    description = "Python 2 and 3 compatibility utilities";
    license = licenses.mit;
    maintainers = teams.kodi.members;
  };
}
