{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  gitMinimal,
  libgit2,
  openssl,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lstr";
  version = "0.4.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "bgreenwell";
    repo = "lstr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uDwf6+By4z1TTkuyg0g5J8zzkM/UCsBMLAF9WfSEreE=";
  };

  cargoHash = "sha256-CGdQmjgOvcLAE88nocn/iA4qfS98CEsseoNn/0udd0s=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    (lib.getDev openssl)
    libgit2
  ];

  nativeCheckInputs = [ gitMinimal ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  meta = {
    description = "Fast, minimalist directory tree viewer written in Rust";
    homepage = "https://github.com/bgreenwell/lstr";
    changelog = "https://github.com/bgreenwell/lstr/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      DieracDelta
      philiptaron
    ];
    mainProgram = "lstr";
  };
})
