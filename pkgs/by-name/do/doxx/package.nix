{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "doxx";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "bgreenwell";
    repo = "doxx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0+7R0kdCcw+PdX4UfYuacCv86nzJW+LgTVml9drGZXE=";
  };

  cargoHash = "sha256-Eix63WAxOdK4//WBDfAdqMrtHCM1VSepSy841hCndeI=";

  # https://github.com/bgreenwell/doxx/issues/65
  checkFlags = [ "--skip=terminal_image::tests::test_renderer_creation" ];

  postInstall = ''
    rm $out/bin/generate_test_docs
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal document viewer for .docx files";
    longDescription = ''
      `doxx` is a lightning-fast, terminal-native document viewer for
      Microsoft Word files. Built with Rust for performance and
      reliability, it brings Word documents to your command line with
      beautiful rendering, smart table support, and powerful export
      capabilities.
    '';
    homepage = "https://github.com/bgreenwell/doxx";
    changelog = "https://github.com/bgreenwell/doxx/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "doxx";
  };
})
