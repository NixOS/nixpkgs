{
  lib,
  fetchFromGitHub,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pie-cli";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "Falconerd";
    repo = "pie";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-qJaQyet6pjvPhBg6p0wxSIJtZE+P7A7XVqzAnvGn12E=";
  };

  buildPhase = ''
    runHook preBuild
    ${stdenv.cc.targetPrefix}cc -o pie pie_cli/pie.c -lm
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm 755 pie $out/bin/pie
    runHook postInstall
  '';

  meta = {
    description = "Simple image format optimised for pixel art";
    homepage = "https://github.com/Falconerd/pie";
    maintainers = with lib.maintainers; [ sigmanificient ];
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
})
