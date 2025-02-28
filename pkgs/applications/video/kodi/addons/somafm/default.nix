{
  lib,
  rel,
  buildKodiAddon,
  fetchzip,
  addonUpdateScript,
}:

buildKodiAddon rec {
  pname = "somafm";
  namespace = "plugin.audio.somafm";
  version = "2.0.1";

  src = fetchzip {
    url = "https://mirrors.kodi.tv/addons/${lib.toLower rel}/plugin.audio.somafm/plugin.audio.somafm-${version}.zip";
    sha256 = "sha256-auPLm7QFabU4tXJPjTl17KpE+lqWM2Edbd2HrXPRx40=";
  };

  passthru = {
    pythonPath = "resources/lib";
    updateScript = addonUpdateScript {
      attrPath = "kodi.packages.somafm";
    };
  };

  meta = with lib; {
    homepage = "https://github.com/Soma-FM-Kodi-Add-On/plugin.audio.somafm";
    description = "SomaFM addon for Kodi";
    license = licenses.gpl3Plus;
    maintainers = teams.kodi.members;
  };
}
