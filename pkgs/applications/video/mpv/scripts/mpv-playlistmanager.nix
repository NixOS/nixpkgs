{ lib, stdenvNoCC, fetchFromGitHub, youtube-dl }:

stdenvNoCC.mkDerivation rec {
  pname = "mpv-playlistmanager";
  version = "unstable-2022-05-21";

  src = fetchFromGitHub {
    owner = "jonniek";
    repo = "mpv-playlistmanager";
    rev = "bc139f779080469840c55504acbbf36a7c9e6427";
    sha256 = "sha256-70P7QcMucj1isW72Y0I00SWLljvrKd6eMOVG4/5pD70=";
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
