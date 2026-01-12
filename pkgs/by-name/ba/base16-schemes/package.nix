{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "base16-schemes";
  version = "0-unstable-2025-11-08";

  src = fetchFromGitHub {
    owner = "tinted-theming";
    repo = "schemes";
    rev = "4ac26dc99141c1b2a26eb7fefe46e22e07eec77c";
    hash = "sha256-pr+RtDs+3qo0v7ZXfcSdtP0PoDDPU9EHw2Oe5EUwWtQ=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/themes/
    install base16/*.yaml $out/share/themes/

    runHook postInstall
  '';

  meta = {
    description = "All the color schemes for use in base16 packages";
    homepage = "https://github.com/tinted-theming/schemes";
    maintainers = [ lib.maintainers.DamienCassou ];
    license = lib.licenses.mit;
  };
})
