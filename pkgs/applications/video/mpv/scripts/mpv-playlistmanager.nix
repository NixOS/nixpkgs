{ lib, stdenvNoCC, fetchFromGitHub, yt-dlp }:

stdenvNoCC.mkDerivation rec {
  pname = "mpv-playlistmanager";
  version = "unstable-2023-08-09";

  src = fetchFromGitHub {
    owner = "jonniek";
    repo = "mpv-playlistmanager";
    rev = "e479cbc7e83a07c5444f335cfda13793681bcbd8";
    sha256 = "sha256-Nh4g8uSkHWPjwl5wyqWtM+DW9fkEbmCcOsZa4eAF6Cs=";
  };

  postPatch = ''
    substituteInPlace playlistmanager.lua \
      --replace 'youtube_dl_executable = "youtube-dl",' \
      'youtube_dl_executable = "${lib.getBin yt-dlp}/bin/yt-dlp"',
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
