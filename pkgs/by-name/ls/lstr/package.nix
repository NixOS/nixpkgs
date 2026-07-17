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
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "bgreenwell";
    repo = "lstr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lJ6BSvlJiyZUOoz0QuahIgZ6GZ9NDcmvvQ7MEd9c/7U=";
  };

  cargoHash = "sha256-pRPcJwdhrQ+P70zaiuPCAI53lW+zEulqSrK5w8SCraQ=";

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
