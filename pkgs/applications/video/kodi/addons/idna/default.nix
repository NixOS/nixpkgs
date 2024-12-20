{
  lib,
  rel,
  buildKodiAddon,
  fetchzip,
  addonUpdateScript,
}:
buildKodiAddon rec {
  pname = "idna";
  namespace = "script.module.idna";
  version = "3.4.0";

  src = fetchzip {
    url = "https://mirrors.kodi.tv/addons/${lib.toLower rel}/${namespace}/${namespace}-${version}.zip";
    sha256 = "sha256-wS1d1L18v4+RGwxDh7OpKRHB2A4qYwiq6b5mAz7l8Pk=";
  };

  passthru = {
    pythonPath = "lib";
    updateScript = addonUpdateScript {
      attrPath = "kodi.packages.idna";
    };
  };

  meta = with lib; {
    homepage = "https://github.com/Freso/script.module.idna";
    description = "Internationalized Domain Names for Python";
    license = licenses.bsd3;
    maintainers = teams.kodi.members;
  };
}
