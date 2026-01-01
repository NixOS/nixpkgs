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

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/simplejson/simplejson";
    description = "Simple, fast, extensible JSON encoder/decoder for Python";
    license = lib.licenses.mit;
    teams = [ lib.teams.kodi ];
=======
  meta = with lib; {
    homepage = "https://github.com/simplejson/simplejson";
    description = "Simple, fast, extensible JSON encoder/decoder for Python";
    license = licenses.mit;
    teams = [ teams.kodi ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
