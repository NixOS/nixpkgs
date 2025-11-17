{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  gitMinimal,
  openssl,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lstr";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "bgreenwell";
    repo = "lstr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uaefVDSTphboWW1BP2HkcuMiW87FmnVYxCthlrAKF5Y=";
  };

  cargoHash = "sha256-UVaqkNV1cNpbCNphk6YMqOz077xY9dUBgCGt7SLIH0U=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ (lib.getDev openssl) ];

  nativeCheckInputs = [ gitMinimal ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  meta = {
    description = "Fast, minimalist directory tree viewer written in Rust";
    homepage = "https://github.com/bgreenwell/lstr";
    changelog = "https://github.com/bgreenwell/lstr/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      DieracDelta
      philiptaron
    ];
    mainProgram = "lstr";
  };
})
