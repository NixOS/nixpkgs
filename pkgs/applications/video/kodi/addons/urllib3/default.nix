{ lib, buildKodiAddon, fetchzip, addonUpdateScript }:

buildKodiAddon rec {
  pname = "urllib3";
  namespace = "script.module.urllib3";
  version = "1.26.16+matrix.1";

  src = fetchzip {
    url = "https://mirrors.kodi.tv/addons/nexus/${namespace}/${namespace}-${version}.zip";
    sha256 = "sha256-HI99Cle/SpwulbDCVoDNy/0EfHVt4q7+LR60YRMaSFY=";
  };

  passthru = {
    pythonPath = "lib";
    updateScript = addonUpdateScript {
      attrPath = "kodi.packages.urllib3";
    };
  };

  meta = with lib; {
    homepage = "https://urllib3.readthedocs.io/en/latest/";
    description = "HTTP library with thread-safe connection pooling, file post, and more";
    license = licenses.mit;
    maintainers = teams.kodi.members;
  };
}
