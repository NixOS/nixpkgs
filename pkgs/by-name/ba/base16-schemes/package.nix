{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "base16-schemes";
  version = "0-unstable-2026-01-15";

  src = fetchFromGitHub {
    owner = "tinted-theming";
    repo = "schemes";
    rev = "43dd14f6466a782bd57419fdfb5f398c74d6ac53";
    hash = "sha256-AWTIYZ1tZab0YwAQwgt5yO4ucqZoc4iXX002Byy7pRY=";
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
