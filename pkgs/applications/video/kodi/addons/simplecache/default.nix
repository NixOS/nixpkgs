{
  lib,
  rel,
  buildKodiAddon,
  fetchzip,
  addonUpdateScript,
}:

buildKodiAddon rec {
  pname = "simplecache";
  namespace = "script.module.simplecache";
  version = "2.0.2";

  src = fetchzip {
    url = "https://mirrors.kodi.tv/addons/${lib.toLower rel}/${namespace}/${namespace}-${version}.zip";
    sha256 = "sha256-xdOBIi99nspcDIKkjxcW1r/BqL8O9NxdDViTuvMtUmo=";
  };

  passthru = {
    pythonPath = "lib";
    updateScript = addonUpdateScript {
      attrPath = "kodi.packages.simplecache";
    };
  };

  meta = {
    homepage = "https://github.com/kodi-community-addons/script.module.simplecache";
    description = "Simple object cache for Kodi addons";
    license = lib.licenses.asl20;
    teams = [ lib.teams.kodi ];
  };
}
