{
  buildLua,
  fetchFromGitHub,
  curl,
  unstableGitUpdater,
  lib,
}:

buildLua rec {
  pname = "youtube-upnext";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "cvzi";
    repo = "mpv-youtube-upnext";
    rev = "v${version}";
    hash = "sha256-x9mfyc8JIlOpbSfGEwxXoUtsH0A+K3JPwT/8MHq7ks4=";
  };

  postPatch = ''
    substituteInPlace youtube-upnext.lua \
      --replace-fail '"curl"' '"${lib.getExe curl}"'
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "A userscript that allows you to play 'up next'/recommended youtube videos";
    homepage = "https://github.com/cvzi/mpv-youtube-upnext";
    maintainers = with maintainers; [ bddvlpr ];
    license = licenses.unfree;
  };
}
