{
  lib,
  rel,
  buildKodiAddon,
  fetchzip,
  addonUpdateScript,
  inputstreamhelper,
  plugin-cache,
}:

buildKodiAddon rec {
  pname = "raiplay";
  namespace = "plugin.video.raitv";
  version = "4.1.2";

  propagatedBuildInputs = [
    plugin-cache
    inputstreamhelper
  ];

  src = fetchzip {
    url = "https://mirrors.kodi.tv/addons/${lib.toLower rel}/${namespace}/${namespace}-${version}.zip";
    sha256 = "sha256-9aR1kkl+0+nhP0bOTnaKCgSfuPvJzX5TWHU0WJZIvSM=";
  };

  passthru = {
    updateScript = addonUpdateScript {
      attrPath = "kodi.packages.raiplay";
    };
  };

  meta = with lib; {
    homepage = "https://github.com/maxbambi/plugin.video.raitv/";
    description = "Live radio and TV channels, latest 7 days of programming, broadcast archive, news";
    license = licenses.gpl3Only;
    maintainers = teams.kodi.members;
  };
}
