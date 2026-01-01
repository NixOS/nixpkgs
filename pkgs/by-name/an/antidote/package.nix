{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
<<<<<<< HEAD
  version = "1.9.11";
=======
  version = "1.9.10";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pname = "antidote";

  src = fetchFromGitHub {
    owner = "mattmc3";
    repo = "antidote";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-5vSScLtC8gbHW3rwPZL7ENwwblN7h2QovvWlewlRHAY=";
=======
    hash = "sha256-+hp8L1Pcqx/Jly1H6F23U4WD6MkVAAZZpPrbc/VSurM=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
    maintainers = [ lib.maintainers.hitsmaxft ];
    platforms = lib.platforms.all;
  };
})
