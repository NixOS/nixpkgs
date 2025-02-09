{ lib, buildLua, fetchFromGitHub, yt-dlp }:

buildLua rec {
  pname = "mpv-playlistmanager";
  version = "unstable-2023-11-28";

  src = fetchFromGitHub {
    owner = "jonniek";
    repo = "mpv-playlistmanager";
    rev = "579490c7ae1becc129736b7632deec4f3fb90b99";
    hash = "sha256-swOtoB8UV/HPTpQRGXswAfUYsyC2Nj/QRIkGP8X1jk0=";
  };

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
