{ lib, stdenvNoCC, fetchFromGitHub, youtube-dl }:

stdenvNoCC.mkDerivation rec {
  pname = "mpv-playlistmanager";
  version = "unstable-2021-09-27";

  src = fetchFromGitHub {
    owner = "jonniek";
    repo = "mpv-playlistmanager";
    rev = "9a759b300c92b55e82be5824fe058e263975741a";
    sha256 = "qMzDJlouBptwyNdw2ag4VKEtmkQNUlos0USPerBAV/s=";
  };

  postPatch = ''
    substituteInPlace playlistmanager.lua \
    --replace "'youtube-dl'" "'${youtube-dl}/bin/youtube-dl'" \
  '';

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/mpv/scripts
    cp playlistmanager.lua $out/share/mpv/scripts
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
