{
  lib,
  rel,
  buildKodiAddon,
  fetchzip,
  addonUpdateScript,
}:
buildKodiAddon rec {
  pname = "myconnpy";
  namespace = "script.module.myconnpy";
  version = "8.0.33";

  src = fetchzip {
    url = "https://mirrors.kodi.tv/addons/${lib.toLower rel}/${namespace}/${namespace}-${version}.zip";
    sha256 = "sha256-NlLMq9RAdWu8rVsMc0FDe1HmQiVp5T7iBXbIH7HB5bI=";
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
