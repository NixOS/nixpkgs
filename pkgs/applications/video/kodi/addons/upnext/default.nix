{ lib, rel, buildKodiAddon, fetchzip, addonUpdateScript }:

buildKodiAddon rec {
  pname = "upnext";
  namespace = "service.upnext";
  version = "1.1.9+matrix.1";

  src = fetchzip {
    url = "https://mirrors.kodi.tv/addons/${lib.toLower rel}/${namespace}/${namespace}-${version}.zip";
    sha256 = "sha256-oNUk80MEzK6Qssn1KjT6psPTazISRoUif1IMo+BKJxo=";
  };

  passthru = {
    pythonPath = "resources/lib";
    updateScript = addonUpdateScript {
      attrPath = "kodi.packages.upnext";
    };
  };

  meta = with lib; {
    homepage = "https://github.com/im85288/service.upnext";
    description = "Up Next - Proposes to play the next episode automatically";
    license = licenses.gpl2Only;
    maintainers = teams.kodi.members;
  };
}
