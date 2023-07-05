{ lib, buildKodiAddon, fetchzip, addonUpdateScript }:

buildKodiAddon rec {
  pname = "simplejson";
  namespace = "script.module.simplejson";
  version = "3.17.0+matrix.2";

  src = fetchzip {
    url = "https://mirrors.kodi.tv/addons/nexus/${namespace}/${namespace}-${version}.zip";
    sha256 = "sha256-XLE4x0qr3CFwWqh1BfSg9q+w6pWgFBXG7TyVJWeGQIs=";
  };

  passthru = {
    pythonPath = "lib";
    updateScript = addonUpdateScript {
      attrPath = "kodi.packages.simplejson";
    };
  };

  meta = with lib; {
    homepage = "https://github.com/simplejson/simplejson";
    description = "Simple, fast, extensible JSON encoder/decoder for Python";
    license = licenses.mit;
    maintainers = teams.kodi.members;
  };
}
