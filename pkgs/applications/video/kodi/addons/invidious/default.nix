{
  lib,
  rel,
  buildKodiAddon,
  fetchzip,
  addonUpdateScript,
  infotagger,
  requests,
  inputstream-adaptive,
  inputstreamhelper,
}:

buildKodiAddon rec {
  pname = "invidious";
  namespace = "plugin.video.invidious";
  version = "0.2.6";

  src = fetchzip {
    url = "https://mirrors.kodi.tv/addons/${lib.toLower rel}/plugin.video.invidious/plugin.video.invidious-${version}+nexus.0.zip";
    sha256 = "sha256-XnlnhvtHMh4uQTupW/SSOmaEV8xZrL61/6GoRpyKR0o=";
  };

  propagatedBuildInputs = [
    infotagger
    requests
    inputstream-adaptive
    inputstreamhelper
  ];

  passthru = {
    pythonPath = "resources/lib";
    updateScript = addonUpdateScript {
      attrPath = "kodi.packages.invidious";
    };
  };

  meta = with lib; {
    homepage = "https://github.com/petterreinholdtsen/kodi-invidious-plugin";
    description = "A privacy-friendly way of watching YouTube content";
    license = licenses.mit;
    maintainers = teams.kodi.members;
  };
}
