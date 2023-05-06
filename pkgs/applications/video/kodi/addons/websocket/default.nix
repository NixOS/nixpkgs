{ lib, buildKodiAddon, fetchzip, addonUpdateScript, six, addonDir }:

buildKodiAddon rec {
  pname = "websocket";
  namespace = "script.module.websocket";
  version = "0.58.0+matrix.2";

  src = fetchzip {
    url = "https://mirrors.kodi.tv/addons/nexus/${namespace}/${namespace}-${version}.zip";
    sha256 = "sha256-xyOlKAAvtucC/tTm027ifEgiry/9gQneAcIwOGxmTkg=";
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
