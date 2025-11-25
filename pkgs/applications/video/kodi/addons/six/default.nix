{
  lib,
  rel,
  buildKodiAddon,
  fetchzip,
  addonUpdateScript,
}:

buildKodiAddon rec {
  pname = "six";
  namespace = "script.module.six";
  version = "1.16.0+matrix.1";

  src = fetchzip {
    url = "https://mirrors.kodi.tv/addons/${lib.toLower rel}/${namespace}/${namespace}-${version}.zip";
    sha256 = "sha256-d6BNpnTg6K7NPX3uWp5X0rog33C+B7YoAtLH/CrUYno=";
  };

  passthru = {
    pythonPath = "lib";
    updateScript = addonUpdateScript {
      attrPath = "kodi.packages.six";
    };
  };

  meta = with lib; {
    homepage = "https://pypi.org/project/six/";
    description = "Python 2 and 3 compatibility utilities";
    license = licenses.mit;
    teams = [ teams.kodi ];
  };
}
