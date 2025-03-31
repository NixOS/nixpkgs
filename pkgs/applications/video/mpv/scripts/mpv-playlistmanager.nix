{
  lib,
  buildLua,
  fetchFromGitHub,
  unstableGitUpdater,
  yt-dlp,
}:

buildLua {
  pname = "mpv-playlistmanager";
  version = "0-unstable-2025-03-16";

  src = fetchFromGitHub {
    owner = "jonniek";
    repo = "mpv-playlistmanager";
    rev = "a2755132c18c050269e5fea6093672f0a36ed7db";
    hash = "sha256-v+zQiRXPtFXSq3Em3sA37zltUGPhGCpONJ25F2Jxe4w=";
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
