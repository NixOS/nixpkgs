{
  lib,
  fetchFromGitHub,
  unstableGitUpdater,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "alacritty-theme";
  version = "0-unstable-2026-11-24";

  src = fetchFromGitHub {
    owner = "alacritty";
    repo = "alacritty-theme";
    rev = "52d05307d64d988e16678f98f876b54592c2777f";
    hash = "sha256-WNdnDzBte/FNN1y9eiY4ZBdfWaAdc0xX1VnVPPGWpGM=";
    sparseCheckout = [ "themes" ];
  };

  dontConfigure = true;
  dontBuild = true;
  preferLocalBuild = true;

  sourceRoot = "${finalAttrs.src.name}/themes";
  installPhase = ''
    runHook preInstall
    install -Dt $out/share/alacritty-theme *.toml
    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater {
    hardcodeZeroVersion = true;
  };

  meta = {
    description = "Collection of Alacritty color schemes";
    homepage = "https://alacritty.org/";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.nicoo ];
    platforms = lib.platforms.all;
  };
})
