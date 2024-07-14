{
  lib,
  buildLua,
  fetchFromGitHub,
  unstableGitUpdater,
  yt-dlp,
}:

buildLua rec {
  pname = "mpv-playlistmanager";
  version = "0-unstable-2024-02-26";

  src = fetchFromGitHub {
    owner = "jonniek";
    repo = "mpv-playlistmanager";
    rev = "1911dc053951169c98cfcfd9f44ef87d9122ca80";
    hash = "sha256-pcdOMhkivLF5B86aNuHrqj77DuYLAFGlwFwY7jxkDkE=";
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
