{
  lib,
  buildLua,
  fetchFromGitHub,
  unstableGitUpdater,
  yt-dlp,
}:

buildLua {
  pname = "mpv-playlistmanager";
  version = "0-unstable-2026-03-16";

  src = fetchFromGitHub {
    owner = "jonniek";
    repo = "mpv-playlistmanager";
    rev = "2eb09e1e7a2f66549145b728d570fda83703ed86";
    hash = "sha256-NZ6tRq0DLzg1NlpIwbMZPoWQmJZ0cynDuyF5TGazOfc=";
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
