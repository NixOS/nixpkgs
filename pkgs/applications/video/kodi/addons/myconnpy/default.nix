{ lib, buildKodiAddon, fetchzip, addonUpdateScript }:
buildKodiAddon rec {
  pname = "myconnpy";
  namespace = "script.module.myconnpy";
  version = "8.0.18+matrix.1";

  src = fetchzip {
    url = "https://mirrors.kodi.tv/addons/matrix/${namespace}/${namespace}-${version}.zip";
    sha256 = "1cx3qdzw9lkkmbyvyrmc2i193is20fihn2sfl7kmv43f708vam0k";
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
