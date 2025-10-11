{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "base16-schemes";
  version = "0-unstable-2025-9-25";

  src = fetchFromGitHub {
    owner = "tinted-theming";
    repo = "schemes";
    rev = "317a5e10c35825a6c905d912e480dfe8e71c7559";
    hash = "sha256-d4km8W7w2zCUEmPAPUoLk1NlYrGODuVa3P7St+UrqkM=";
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
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      DamienCassou
      nyxar77
    ];
  };
})
