{
  lib,
  buildDubPackage,
  fetchFromGitHub,
}:
buildDubPackage (finalAttrs: {
  pname = "ddhx";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "dd86k";
    repo = "ddhx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gO6oXVkEfcgWIA2phap3JOOh9t3JpKi+BINeXdcmFTA=";
  };

  dubLock.dependencies = { };

  installPhase = ''
    runHook preInstall
    install -Dm755 ddhx -t $out/bin
    runHook postInstall
  '';

  doCheck = true;

  meta = {
    description = "Console text-mode hex editor, inspired by GNU nano and vim";
    homepage = "https://github.com/dd86k/ddhx";
    changelog = "https://github.com/dd86k/ddhx/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ryand56 ];
    platforms = lib.platforms.unix;
    mainProgram = "ddhx";
  };
})
