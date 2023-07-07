{ lib, buildKodiAddon, fetchzip, addonUpdateScript }:
buildKodiAddon rec {
  pname = "myconnpy";
  namespace = "script.module.myconnpy";
  version = "8.0.18+matrix.1";

  src = fetchzip {
    url = "https://mirrors.kodi.tv/addons/nexus/${namespace}/${namespace}-${version}.zip";
    sha256 = "sha256-E1S1EThukF3noU4LC6MDQseRQhSsZr/9qnPSxH/Do7M=";
  };

  passthru = {
    pythonPath = "lib";
    updateScript = addonUpdateScript {
      attrPath = "kodi.packages.myconnpy";
    };
  };

  meta = with lib; {
    homepage = "http://dev.mysql.com/doc/connector-python/en/index.html";
    description = "MySQL Connector/Python";
    license = licenses.gpl2Only;
    maintainers = teams.kodi.members;
  };
}
