{ lib, buildKodiAddon, fetchFromGitHub, addonUpdateScript, requests, inputstream-adaptive, inputstreamhelper }:

buildKodiAddon rec {
  pname = "invidious";
  namespace = "plugin.video.invidious";
  version = "unstable-2022-11-28";

  # video search doesn't work for the version on kodi.tv
  # if the result contains channels
  # https://github.com/TheAssassin/kodi-invidious-plugin/issues/17
  src = fetchFromGitHub {
    owner = "TheAssassin";
    repo = "kodi-invidious-plugin";
    rev = "85b66525632d94630c9301d9c490fc002a335d77";
    hash = "sha256-DpsAQUOUYCs3rpWwsk82+00KME4J+Iocu/v781dyyws=";
  };

  propagatedBuildInputs = [
    requests
    inputstream-adaptive
    inputstreamhelper
  ];

  passthru = {
    pythonPath = "resources/lib";
  };

  meta = with lib; {
    homepage = "https://github.com/TheAssassin/kodi-invidious-plugin";
    description = "A privacy-friendly way of watching YouTube content";
    license = licenses.mit;
    maintainers = teams.kodi.members;
  };
}
