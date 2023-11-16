{ lib, buildLua, fetchFromGitHub, yt-dlp }:

buildLua rec {
  pname = "mpv-playlistmanager";
  version = "unstable-2023-11-16";

  src = fetchFromGitHub {
    owner = "jonniek";
    repo = "mpv-playlistmanager";
    rev = "cd5242996247a4b0d1fde7e7907d0b6e60a815ac";
    sha256 = "sha256-qjkh3Q/78c4TfSSH/xQqQndRY6JwfLuYftci+sEqMWo=";
  };

  postPatch = ''
    substituteInPlace playlistmanager.lua \
      --replace 'youtube_dl_executable = "youtube-dl",' \
      'youtube_dl_executable = "${lib.getBin yt-dlp}/bin/yt-dlp"',
  '';

  scriptPath = "playlistmanager.lua";

  meta = with lib; {
    description = "Mpv lua script to create and manage playlists";
    homepage = "https://github.com/jonniek/mpv-playlistmanager";
    license = licenses.unlicense;
    maintainers = with maintainers; [ lunik1 ];
  };
}
