{
  lib,
  rel,
  buildKodiAddon,
  fetchzip,
  addonUpdateScript,
}:

buildKodiAddon rec {
  pname = "upnext";
  namespace = "service.upnext";
  version = "1.3.0";

  src = fetchzip {
    url = "https://mirrors.kodi.tv/addons/${lib.toLower rel}/${namespace}/${namespace}-${version}.zip";
    hash = "sha256-R718Py4lq8RcfbfTexWLOP3mGB+lV1U8apofQ8lasRY=";
  };

  passthru = {
    pythonPath = "resources/lib";
    updateScript = addonUpdateScript {
      attrPath = "kodi.packages.upnext";
    };
  };

  meta = {
    homepage = "https://github.com/im85288/service.upnext";
    description = "Up Next - Proposes to play the next episode automatically";
    license = lib.licenses.gpl2Only;
    teams = [ lib.teams.kodi ];
  };
}
