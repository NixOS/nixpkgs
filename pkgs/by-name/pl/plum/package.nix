{
  lib,
  stdenv,
  fetchFromGitHub,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "plum";
  version = "2.2.0";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "plumlang";
    repo = "plumlang";
    tag = "v${finalAttrs.version}";
    hash = "sha256-th1RCqG5UnJ/pgvNCkLeNbUImRjLU7vvvp3vsP1UNeM=";
  };

  # The Makefile asks git for the commit `plum version` prints; there is no
  # .git in the source, so give it the tag.
  makeFlags = [ "COMMIT=${finalAttrs.src.tag}" ];

  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 plum "$out/bin/plum"
    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";
  doInstallCheck = true;

  meta = {
    description = "Small, fast, memory-safe programming language";
    homepage = "https://plum.elixpo.com";
    changelog = "https://github.com/plumlang/plumlang/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    mainProgram = "plum";
    maintainers = with lib.maintainers; [ Circuit-Overtime ];
    platforms = lib.platforms.unix;
  };
})
