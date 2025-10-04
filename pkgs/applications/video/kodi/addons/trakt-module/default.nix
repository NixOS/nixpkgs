{
  lib,
  rel,
  buildKodiAddon,
  fetchzip,
  addonUpdateScript,
  requests,
  six,
  arrow,
}:
buildKodiAddon rec {
  pname = "trakt-module";
  namespace = "script.module.trakt";
  version = "4.4.0+matrix.1";

  src = fetchzip {
    url = "https://mirrors.kodi.tv/addons/${lib.toLower rel}/${namespace}/${namespace}-${version}.zip";
    sha256 = "sha256-6JIAQwot5VZ36gvQym88BD/e/mSyS8WO8VqkPn2GcqY=";
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
    teams = [ teams.kodi ];
  };
}
