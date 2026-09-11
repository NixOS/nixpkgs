{
  lib,
  buildDubPackage,
  fetchFromGitHub,
}:
buildDubPackage (finalAttrs: {
  pname = "ddhx";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "dd86k";
    repo = "ddhx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vmWO7NodB5j5ZhzdiB9H3hzXVgW5MCqlGlnp7VKnui0=";
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
