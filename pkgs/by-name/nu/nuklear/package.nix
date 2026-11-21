{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "nuklear";
  version = "4.13.3";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "Immediate-Mode-UI";
    repo = "Nuklear";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6mT8bV39UCnUoTH6lsuwIgFmuakxA9+vCNxlcU+5jbU=";
  };

  installPhase = ''
    runHook preInstall
    install -Dm 644 nuklear.h -t $out/include
    runHook postInstall
  '';

  meta = {
    description = "Single-header ANSI C immediate mode cross-platform GUI library";
    homepage = "https://immediate-mode-ui.github.io/Nuklear";
    license = with lib.licenses; [
      mit # OR
      publicDomain
    ];
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      tkpmonke
    ];
  };
})
