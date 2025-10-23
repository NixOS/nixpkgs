{
  lib,
  rel,
  buildKodiAddon,
  fetchzip,
  addonUpdateScript,
}:

buildKodiAddon rec {
  pname = "simplejson";
  namespace = "script.module.simplejson";
  version = "3.19.1+matrix.1";

  src = fetchzip {
    url = "https://mirrors.kodi.tv/addons/${lib.toLower rel}/${namespace}/${namespace}-${version}.zip";
    sha256 = "sha256-RJy75WAr0XmXnSrPjqKhFjWJnWo3c5IEtUGumcE/mRo=";
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
    teams = [ teams.kodi ];
  };
}
