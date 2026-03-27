{
  lib,
  rel,
  buildKodiAddon,
  fetchzip,
  addonUpdateScript,
}:
buildKodiAddon rec {
  pname = "signals";
  namespace = "script.module.addon.signals";
  version = "0.0.6+matrix.1";

  src = fetchzip {
    url = "https://mirrors.kodi.tv/addons/${lib.toLower rel}/${namespace}/${namespace}-${version}.zip";
    sha256 = "sha256-WsLR7iUh5F+LXMISBpWx71dLAtg/AMYF6BsiyKZakuE=";
  };

  passthru = {
    pythonPath = "lib";
    updateScript = addonUpdateScript {
      attrPath = "kodi.packages.signals";
    };
  };

  meta = {
    homepage = "https://github.com/ruuk/script.module.addon.signals";
    description = "Provides signal/slot mechanism for inter-addon communication";
    license = lib.licenses.lgpl21Only;
    teams = [ lib.teams.kodi ];
  };
}
