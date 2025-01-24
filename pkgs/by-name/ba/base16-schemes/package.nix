{
  lib,
  stdenv,
  fetchFromGitHub,
  ...
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "base16-schemes";
  version = "unstable-2024-11-12";

  src = fetchFromGitHub {
    owner = "tinted-theming";
    repo = "schemes";
    rev = "61058a8d2e2bd4482b53d57a68feb56cdb991f0b";
    sha256 = "sha256-Tp1BpaF5qRav7O2TsSGjCfgRzhiasu4IuwROR66gz1o=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/themes/
    install base16/*.yaml $out/share/themes/

    runHook postInstall
  '';

  meta = with lib; {
    description = "All the color schemes for use in base16 packages";
    homepage = finalAttrs.src.meta.homepage;
    maintainers = [ maintainers.DamienCassou ];
    license = licenses.mit;
  };
})
