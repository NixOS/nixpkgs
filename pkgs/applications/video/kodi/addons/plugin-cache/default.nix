{
  lib,
  rel,
  buildKodiAddon,
  fetchzip,
  addonUpdateScript,
}:

buildKodiAddon rec {
  pname = "plugin-cache";
  namespace = "script.common.plugin.cache";
  version = "3.0.0";

  src = fetchzip {
    url = "https://mirrors.kodi.tv/addons/${lib.toLower rel}/${namespace}/${namespace}-${version}.zip";
    sha256 = "sha256-5QcMNmWOEw2C26OXlvAvxqDxTpjIMBhwmaIFwVgHuIU=";
  };

  passthru = {
    pythonPath = "resources/lib";
    updateScript = addonUpdateScript {
      attrPath = "kodi.packages.plugin-cache";
    };
  };

  meta = with lib; {
    homepage = "https://github.com/anxdpanic/script.common.plugin.cache";
    description = "Common plugin cache";
    license = licenses.gpl3Only;
    teams = [ teams.kodi ];
  };
}
