{
  lib,
  rustPlatform,
  stdenvNoCC,
  fetchFromGitHub,
  pkg-config,
  openssl,
  libgit2,
  libssh2,
  gitMinimal,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gittype";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "unhappychoice";
    repo = "gittype";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Yvbtnf+rBLsLIKfzhZR9L7t2SbX5I8Jk9st3FUvD5Wo=";
  };

  cargoHash = "sha256-70lLK+I98iCssfsQovixPCvffaeaHuj43ALBJI6vnw0=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    openssl
    libgit2
    libssh2
  ];

  env = {
    OPENSSL_NO_VENDOR = 1;
    LIBGIT2_NO_VENDOR = 1;
    LIBSSH2_SYS_USE_PKG_CONFIG = 1;
  };

  nativeCheckInputs = [ gitMinimal ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI code-typing game that turns your source code into typing challenges";
    homepage = "https://github.com/unhappychoice/gittype";
    changelog = "https://github.com/unhappychoice/gittype/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ chillcicada ];
    mainProgram = "gittype";
    broken = stdenvNoCC.hostPlatform.isAarch64 && stdenvNoCC.hostPlatform.isDarwin;
  };
})
