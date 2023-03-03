{ lib
, stdenvNoCC
, fetchFromGitHub
}:

let
  src = fetchFromGitHub {
    owner = "occivink";
    repo = "mpv-scripts";
    rev = "af360f332897dda907644480f785336bc93facf1";
    hash = "sha256-KdCrUkJpbxxqmyUHksVVc8KdMn8ivJeUA2eerFZfEE8=";
  };
  version = "unstable-2022-10-02";
in

# Usage: `pkgs.mpv.override { scripts = [ pkgs.mpvScripts.seekTo ]; }`
stdenvNoCC.mkDerivation {
  pname = "mpv_seek-to";
  passthru.scriptName = "seek-to.lua";
  inherit version src;

  dontBuild = true;
  installPhase = ''
    mkdir -p $out/share/mpv/scripts
    cp -r scripts/seek-to.lua $out/share/mpv/scripts/
  '';

  meta = with lib; {
    description = "Mpv script for seeking to a specific position";
    homepage = "https://github.com/occivink/mpv-scripts";
    license = licenses.unlicense;
    platforms = platforms.all;
    maintainers = with maintainers; [ nicoo ];
  };
}
