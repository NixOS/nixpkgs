{ lib, stdenvNoCC, fetchFromGitHub, youtube-dl }:

stdenvNoCC.mkDerivation rec {
  pname = "mpv-playlistmanager";
  version = "unstable-2021-03-09";

  src = fetchFromGitHub {
    owner = "jonniek";
    repo = "mpv-playlistmanager";
    rev = "c15a0334cf6d4581882fa31ddb1e6e7f2d937a3e";
    sha256 = "uxcvgcSGS61UU8MmuD6qMRqpIa53iasH/vkg1xY7MVc=";
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
