{
  lib,
  buildLua,
  fetchFromGitHub,
  unstableGitUpdater,
  yt-dlp,
}:

buildLua {
  pname = "mpv-playlistmanager";
  version = "0-unstable-2025-12-17";

  src = fetchFromGitHub {
    owner = "jonniek";
    repo = "mpv-playlistmanager";
    rev = "75caa611c9dab164e74a04a62abfbf508e51d71e";
    hash = "sha256-wSyxcR+qIWozbDjrZT+B6SgFaigSWofExdsZ2fF7/uY=";
  };
  passthru.updateScript = unstableGitUpdater { };

  postPatch = ''
    substituteInPlace playlistmanager.lua \
      --replace-fail 'youtube_dl_executable = "yt-dlp",' \
      'youtube_dl_executable = "${lib.getExe yt-dlp}"',
  '';

  meta = {
    description = "Mpv lua script to create and manage playlists";
    homepage = "https://github.com/jonniek/mpv-playlistmanager";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ lunik1 ];
  };
}
