{
  lib,
  buildKodiAddon,
  fetchFromGitHub,
}:

buildKodiAddon rec {
  pname = "xbmcswift2";
  namespace = "script.module.xbmcswift2";
  version = "19.0.7";

  src = fetchFromGitHub {
    owner = "XBMC-Addons";
    repo = namespace;
    rev = version;
    sha256 = "sha256-Z+rHz3wncoNvV1pwhRzJFB/X0H6wdfwg88otVh27wg8=";
  };

  passthru = {
    pythonPath = "lib";
  };

  meta = with lib; {
    homepage = "https://github.com/XBMC-Addons/script.module.xbmcswift2";
    description = "Framework to ease development of Kodi addons";
    license = licenses.gpl3Only;
    maintainers = teams.kodi.members;
  };
}
