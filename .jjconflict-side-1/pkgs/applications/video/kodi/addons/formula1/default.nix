{
  lib,
  rel,
  buildKodiAddon,
  fetchzip,
  addonUpdateScript,
  requests,
}:

buildKodiAddon rec {
  pname = "formula1";
  namespace = "plugin.video.formula1";
  version = "2.0.4";

  src = fetchzip {
    url = "https://mirrors.kodi.tv/addons/${lib.toLower rel}/${namespace}/${namespace}-${version}.zip";
    sha256 = "sha256-tyVq/yfnPQ5NAnlYCT8lF/s2voh4NOQPRawXX1+ryTU=";
  };

  propagatedBuildInputs = [
    requests
  ];

  passthru = {
    updateScript = addonUpdateScript {
      attrPath = "kodi.packages.formula1";
    };
  };

  meta = with lib; {
    homepage = "https://github.com/jaylinski/kodi-addon-formula1";
    description = "Videos from the Formula 1 website";
    license = licenses.mit;
    teams = [ teams.kodi ];
  };
}
