{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "2.3.0";
  pname = "antidote";

  src = fetchFromGitHub {
    owner = "mattmc3";
    repo = "antidote";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qPkXbKm0EEivwtQyuVcKPfQYPAJ4MDY/9h3dMzUmDqI=";
  };

  dontPatch = true;
  dontBuild = true;
  dontConfigure = true;
  dontFixup = true;

  installPhase = ''
    runHook preInstall
    install -D antidote --target-directory=$out/share/antidote
    install -D antidote.zsh --target-directory=$out/share/antidote
    install -D functions/* --target-directory=$out/share/antidote/functions
    runHook postInstall
  '';

  meta = {
    description = "Zsh plugin manager made from the ground up thinking about performance";
    homepage = "https://getantidote.github.io/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      hitsmaxft
      NanamiNakano
    ];
    platforms = lib.platforms.all;
  };
})
