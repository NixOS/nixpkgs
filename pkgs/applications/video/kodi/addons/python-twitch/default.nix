{
  lib,
  rel,
  buildKodiAddon,
  fetchzip,
  addonUpdateScript,
  requests,
  six,
}:
buildKodiAddon rec {
  pname = "python-twitch";
  namespace = "script.module.python.twitch";
  version = "3.0.2";

  src = fetchzip {
    url = "https://mirrors.kodi.tv/addons/${lib.toLower rel}/${namespace}/${namespace}-${version}.zip";
    sha256 = "sha256-9MzGrBlMz8nZKTgCJrMAWDxKiZuzlhnTOxbja+XTxCI=";
  };

  propagatedBuildInputs = [
    requests
    six
  ];

  passthru = {
    pythonPath = "lib";
    updateScript = addonUpdateScript {
      attrPath = "kodi.packages.twitch-module";
    };
  };

  meta = {
    homepage = "https://github.com/anxdpanic/script.module.python.twitch";
    description = "Python twitch library packed for Kodi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ itepastra ];
  };
}
