{ lib, buildKodiAddon, fetchzip, addonUpdateScript }:

buildKodiAddon rec {
  pname = "tzdata";
  namespace = "script.module.tzdata";
  version = "2023.3.0+matrix.1";

  src = fetchzip {
    url =
      "https://mirrors.kodi.tv/addons/nexus/${namespace}/${namespace}-${version}.zip";
    sha256 = "sha256-GnoFw7l8l/mYqvPO5TJSPy6TyTicGT36wFr54v8oAmY=";
  };

  passthru = {
    pythonPath = "lib";
  };

  meta = with lib; {
    homepage = "https://pypi.org/project/tzdata/";
    description = "Python package wrapping the IANA time zone database";
    license = licenses.asl20;
    maintainers = teams.kodi.members;
  };
}
