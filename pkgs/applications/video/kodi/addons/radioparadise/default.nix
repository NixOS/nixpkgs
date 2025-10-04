{
  lib,
  rel,
  buildKodiAddon,
  fetchzip,
  addonUpdateScript,
  requests,
}:

buildKodiAddon rec {
  pname = "radioparadise";
  namespace = "script.radioparadise";
  version = "2.2.0";

  src = fetchzip {
    url = "https://mirrors.kodi.tv/addons/${lib.toLower rel}/script.radioparadise/script.radioparadise-${version}.zip";
    sha256 = "sha256-tZb/DW9wJRYWPqH/wuER1lRgI9ePWFBmuqdI6goDrbo=";
  };

  propagatedBuildInputs = [
    requests
  ];

  passthru = {
    pythonPath = "resources/lib";
    updateScript = addonUpdateScript {
      attrPath = "kodi.packages.radioparadise";
    };
  };

  meta = with lib; {
    homepage = "https://github.com/alxndr42/script.radioparadise";
    description = "Radio Paradise addon for Kodi";
    license = licenses.gpl3Plus;
    teams = [ teams.kodi ];
  };
}
