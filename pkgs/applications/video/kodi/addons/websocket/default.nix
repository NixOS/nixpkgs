{ lib, rel, buildKodiAddon, fetchzip, addonUpdateScript, six, addonDir }:

buildKodiAddon rec {
  pname = "websocket";
  namespace = "script.module.websocket";
  version = "1.6.4";

  src = fetchzip {
    url = "https://mirrors.kodi.tv/addons/${lib.toLower rel}/${namespace}/${namespace}-${version}.zip";
    sha256 = "sha256-1Wy+hxB059UoZnQlncytVT3sQ07dYAhNRnW3/QVD4ZE=";
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
    description = "WebSocket client for Python";
    license = licenses.lgpl2Only;
    maintainers = teams.kodi.members;
  };
}
