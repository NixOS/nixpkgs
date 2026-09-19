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
  version = "4.6.0";

  propagatedBuildInputs = [
    plugin-cache
    inputstreamhelper
  ];

  src = fetchzip {
    url = "https://mirrors.kodi.tv/addons/${lib.toLower rel}/${namespace}/${namespace}-${version}.zip";
    sha256 = "sha256-WJDk2Ck5+AvbxuJ3odu1Gsbe0ByGapHYOpCxek/trFk=";
  };

  passthru = {
    updateScript = addonUpdateScript {
      attrPath = "kodi.packages.raiplay";
    };
  };

  meta = {
    homepage = "https://github.com/maxbambi/plugin.video.raitv/";
    description = "Live radio and TV channels, latest 7 days of programming, broadcast archive, news";
    license = lib.licenses.gpl3Only;
    teams = [ lib.teams.kodi ];
  };
}
