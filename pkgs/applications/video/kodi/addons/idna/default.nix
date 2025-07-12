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
  version = "3.10.0";

  src = fetchzip {
    url = "https://mirrors.kodi.tv/addons/${lib.toLower rel}/${namespace}/${namespace}-${version}.zip";
    sha256 = "sha256-wFS7rETO+VGeg1MxMEdb/cwVw5/TEoZF2CS3BjkxDlk=";
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
    teams = [ teams.kodi ];
  };
}
