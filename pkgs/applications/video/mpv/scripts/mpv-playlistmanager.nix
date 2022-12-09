{ lib, stdenvNoCC, fetchFromGitHub, yt-dlp }:

stdenvNoCC.mkDerivation rec {
  pname = "mpv-playlistmanager";
  version = "unstable-2022-08-26";

  src = fetchFromGitHub {
    owner = "jonniek";
    repo = "mpv-playlistmanager";
    rev = "07393162f7f78f8188e976f616f1b89813cec741";
    sha256 = "sha256-Vgh5F6c90ijp5LVrP2cdAOXo+QtJ9aXI9G/3C2HGqd4=";
  };

  postPatch = ''
    substituteInPlace playlistmanager.lua \
      --replace "youtube-dl" "${lib.getBin yt-dlp}/bin/yt-dlp"
  '';

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -D -t $out/share/mpv/scripts playlistmanager.lua
    runHook postInstall
  '';

  passthru.scriptName = "playlistmanager.lua";

  meta = with lib; {
    description = "Mpv lua script to create and manage playlists";
    homepage = "https://github.com/jonniek/mpv-playlistmanager";
    license = licenses.unlicense;
    platforms = platforms.all;
    maintainers = with maintainers; [ lunik1 ];
  };
}
