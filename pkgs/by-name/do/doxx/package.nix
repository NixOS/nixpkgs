{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "doxx";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "bgreenwell";
    repo = "doxx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-V0pBeh9u6iNt6hS1MpUau6nYBdfn9bELhR0GAMqTRmc=";
  };

  cargoHash = "sha256-WsV6IGKO3mwAXtqXHu+CP1dQ/tw1jsuZlfSZx4L2WIM=";

  # https://github.com/bgreenwell/doxx/issues/65
  checkFlags = [ "--skip=terminal_image::tests::test_renderer_creation" ];

  postInstall = ''
    rm $out/bin/generate_test_docs
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

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
