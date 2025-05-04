{
  lib,
  stdenv,
  fetchFromGitHub,
  ...
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "base16-schemes";
  version = "unstable-2025-04-18";

  src = fetchFromGitHub {
    owner = "tinted-theming";
    repo = "schemes";
    rev = "28c26a621123ad4ebd5bbfb34ab39421c0144bdd";
    hash = "sha256-Fg+rdGs5FAgfkYNCs74lnl8vkQmiZVdBsziyPhVqrlY=";
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
