{
  lib,
  buildLua,
  fetchFromGitHub,
  unstableGitUpdater,
  yt-dlp,
}:

buildLua rec {
  pname = "mpv-playlistmanager";
  version = "0-unstable-2024-08-17";

  src = fetchFromGitHub {
    owner = "jonniek";
    repo = "mpv-playlistmanager";
    rev = "d733d8c00cb543a646f2ce5ab5c12bef2dfd6756";
    hash = "sha256-Pv2+dl9QIIwOYmT4sJmPOBHed5pZLMXZaw80mT4s+WQ=";
  };
  passthru.updateScript = unstableGitUpdater { };

  postPatch = ''
    substituteInPlace playlistmanager.lua \
      --replace-fail 'youtube_dl_executable = "yt-dlp",' \
      'youtube_dl_executable = "${lib.getExe yt-dlp}"',
  '';

  meta = with lib; {
    description = "Mpv lua script to create and manage playlists";
    homepage = "https://github.com/jonniek/mpv-playlistmanager";
    license = licenses.unlicense;
    maintainers = with maintainers; [ lunik1 ];
  };
}
