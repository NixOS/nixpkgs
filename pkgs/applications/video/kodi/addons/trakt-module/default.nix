{ lib, buildKodiAddon, fetchzip, addonUpdateScript, requests, six, arrow }:
buildKodiAddon rec {
  pname = "trakt-module";
  namespace = "script.module.trakt";
  version = "4.4.0+matrix.1";

  src = fetchzip {
    url = "https://mirrors.kodi.tv/addons/matrix/${namespace}/${namespace}-${version}.zip";
    sha256 = "19kjhrykx92sy67cajxjckzdwgq47ipwml0bx9vmdr9d191h14p8";
  };

  propagatedBuildInputs = [
    requests
    six
    arrow
  ];

  passthru = {
    pythonPath = "lib";
    updateScript = addonUpdateScript {
      attrPath = "kodi.packages.trakt-module";
    };
  };

  meta = with lib; {
    homepage = "https://github.com/Razzeee/script.module.trakt";
    description = "Python trakt.py library packed for Kodi";
    license = licenses.mit;
    maintainers = teams.kodi.members;
  };
}
