{ lib, buildKodiAddon, fetchzip, addonUpdateScript }:

buildKodiAddon rec {
  pname = "six";
  namespace = "script.module.six";
  version = "1.15.0+matrix.1";

  src = fetchzip {
    url = "https://mirrors.kodi.tv/addons/nexus/${namespace}/${namespace}-${version}.zip";
    sha256 = "sha256-zjbPAEB39dWpNsgoBqCKpLLXmqBI/v0wnnbCTRhYGzE=";
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
