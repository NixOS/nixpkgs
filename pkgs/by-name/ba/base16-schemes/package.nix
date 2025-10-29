{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "base16-schemes";
  version = "0-unstable-2025-06-04";

  src = fetchFromGitHub {
    owner = "tinted-theming";
    repo = "schemes";
    rev = "de3eeb6add0a6051bfc717684e36c8c9a78a1812";
    hash = "sha256-C8VZuwzaQfNYbQQcc0Fh4RS+1nqc6j+IOy80NGmV4IQ=";
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
