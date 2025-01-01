{
  lib,
  rel,
  buildKodiAddon,
  fetchzip,
  addonUpdateScript,
}:

buildKodiAddon rec {
  pname = "future";
  namespace = "script.module.future";
  version = "1.0.0+matrix.1";

  src = fetchzip {
    url = "https://mirrors.kodi.tv/addons/${lib.toLower rel}/${namespace}/${namespace}-${version}.zip";
    sha256 = "sha256-BsDgCAZuJBRBpe6EmfSynhrXS3ktQRZsEwf9CdF0VCg=";
  };

  passthru = {
    pythonPath = "lib";
    updateScript = addonUpdateScript {
      attrPath = "kodi.packages.future";
    };
  };

  meta = with lib; {
    homepage = "https://python-future.org";
    description = "Missing compatibility layer between Python 2 and Python 3";
    license = licenses.mit;
    maintainers = teams.kodi.members;
  };
}
