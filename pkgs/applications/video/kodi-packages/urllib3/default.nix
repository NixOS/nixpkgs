{ lib, buildKodiAddon, fetchzip, addonUpdateScript }:
buildKodiAddon rec {
  pname = "urllib3";
  namespace = "script.module.urllib3";
  version = "1.26.4+matrix.1";

  src = fetchzip {
    url = "https://mirrors.kodi.tv/addons/matrix/${namespace}/${namespace}-${version}.zip";
    sha256 = "1d2k6gbsnhdadcl1xc7igz4m71z2fcnpln5ppfjv455cmkk110vf";
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
