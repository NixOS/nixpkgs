{ lib, stdenvNoCC, fetchFromGitHub, youtube-dl }:

stdenvNoCC.mkDerivation rec {
  pname = "mpv-playlistmanager";
  version = "unstable-2021-08-17";

  src = fetchFromGitHub {
    owner = "jonniek";
    repo = "mpv-playlistmanager";
    rev = "44d6911856a39e9a4057d19b70f21a9bc18bd6a9";
    sha256 = "IwH6XngfrZlKGDab/ut43hzHeino8DmWzWRX8Av21Sk=";
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
