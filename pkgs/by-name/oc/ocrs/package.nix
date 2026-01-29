{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ocrs";
  version = "0.10.4";

  src = fetchFromGitHub {
    owner = "robertknight";
    repo = "ocrs";
    tag = "ocrs-v${finalAttrs.version}";
    hash = "sha256-P+nOSlbcetxwEuuv64lmUEUB8fpBLUPd96+YBzD86u4=";
  };

  cargoHash = "sha256-NA7NR2iV83UxJGlpBg6Zy+fMwe3WP8VQKi89lWWoN5c=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Library and tool for OCR, extracting text from images";
    homepage = "https://github.com/robertknight/ocrs";
    mainProgram = "ocrs";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [
      multisn8
    ];
  };
})
