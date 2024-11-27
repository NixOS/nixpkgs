{
  lib,
  rel,
  buildKodiAddon,
  fetchzip,
  addonUpdateScript,
  requests,
  python-twitch,
}:
buildKodiAddon rec {
  pname = "twitch";
  namespace = "plugin.video.twitch";
  version = "3.0.1";

  src = fetchzip {
    url = "https://mirrors.kodi.tv/addons/${lib.toLower rel}/${namespace}/${namespace}-${version}.zip";
    sha256 = "sha256-EQj4/yejzUVzLfiYHw38ip1DIqfShnEVrxcfLYjbBaI=";
  };

  propagatedBuildInputs = [
    requests
    python-twitch
  ];

  passthru = {
    pythonPath = "lib";
    updateScript = addonUpdateScript {
      attrPath = "kodi.packages.trakt";
    };
  };

  meta = {
    homepage = "https://kodi.wiki/view/Add-on:Twitch";
    description = "Twitch.tv livestream integration";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ itepastra ];
  };
}
