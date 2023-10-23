{ lib
, fetchFromGitHub
, nix-update-script
, stdenvNoCC }:

stdenvNoCC.mkDerivation {
  pname = "chapterskip";
  passthru.scriptName = "chapterskip.lua";

  version = "unstable-2022-09-08";
  src = fetchFromGitHub {
    owner = "po5";
    repo  = "chapterskip";
    rev   = "b26825316e3329882206ae78dc903ebc4613f039";
    hash  = "sha256-OTrLQE3rYvPQamEX23D6HttNjx3vafWdTMxTiWpDy90=";
  };

  dontBuild = true;
  preferLocalBuild = true;
  installPhase = "install -Dt $out/share/mpv/scripts chapterskip.lua";

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = with lib; {
    homepage = "https://github.com/po5/chapterskip";
    platforms = platforms.all;
    maintainers = with maintainers; [ nicoo ];
  };
}
