{ lib, buildKodiAddon, fetchzip, addonUpdateScript, six, addonDir }:

buildKodiAddon rec {
  pname = "websocket";
  namespace = "script.module.websocket";
  version = "0.58.0+matrix.2";

  src = fetchzip {
    url = "https://mirrors.kodi.tv/addons/matrix/${namespace}/${namespace}-${version}.zip";
    sha256 = "0j2fcrn3hc6207g0k0gx5ypj4j3ww9pd7rnlzq1fgdig00laa8y7";
  };

  propagatedBuildInputs = [
    six
  ];

  passthru = {
    pythonPath = "lib";
    updateScript = addonUpdateScript {
      attrPath = "kodi.packages.websocket";
    };
  };

  meta = with lib; {
    homepage = "https://github.com/websocket-client/websocket-client";
    description = "A WebSocket client for Python";
    license = licenses.lgpl2Only;
    maintainers = teams.kodi.members;
  };
}
