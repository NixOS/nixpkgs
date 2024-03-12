{ lib, buildLua, fetchFromGitHub, unstableGitUpdater, yt-dlp }:

buildLua rec {
  pname = "mpv-playlistmanager";
  version = "unstable-2024-02-26";

  src = fetchFromGitHub {
    owner = "jonniek";
    repo = "mpv-playlistmanager";
    rev = "1911dc053951169c98cfcfd9f44ef87d9122ca80";
    hash = "sha256-pcdOMhkivLF5B86aNuHrqj77DuYLAFGlwFwY7jxkDkE=";
  };
  passthru.updateScript = unstableGitUpdater {};

  postPatch = ''
    substituteInPlace playlistmanager.lua \
      --replace 'youtube_dl_executable = "youtube-dl",' \
      'youtube_dl_executable = "${lib.getBin yt-dlp}/bin/yt-dlp"',
  '';

  meta = with lib; {
    description = "Mpv lua script to create and manage playlists";
    homepage = "https://github.com/jonniek/mpv-playlistmanager";
    license = licenses.unlicense;
    maintainers = with maintainers; [ lunik1 ];
  };
}
