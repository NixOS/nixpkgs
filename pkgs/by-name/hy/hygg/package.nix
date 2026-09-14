{
  lib,
  pkgs,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hygg";
  version = "0.1.21";

  src = fetchFromGitHub {
    owner = "kruseio";
    repo = "hygg";
    tag = finalAttrs.version;
    hash = "sha256-Gu56WH7Sp1y/fXwEOOACUAe8nshvc6d2302YwPvM+ZM=";
  };

  cargoHash = "sha256-AUkwjgF/LwOvbhOWcrK8ayvL2/MSc7GFh+/bfdZ28/8=";

  nativeBuildInputs = [
    writableTmpDirAsHomeHook
  ];
  checkFlags = [
    # e2e test fails since it cant find the input pdf file
    "--skip=tests::test_end_to_end"
    "--skip=test_epub_processing"
  ]
  ## Skipping this test due to the high variability of its outcome
  ## When the package was merged the test was passing but on hydra its not
  ## Look at PR #448907
  ++ (if pkgs.stdenv.hostPlatform.isDarwin then [ "--skip=test_stdin_processing" ] else [ ]);

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Minimalistic Vim-like TUI document reader";
    longDescription = ''
      Hygg provides universal document support for PDF,EPUB DOCX amongst others
      It also comes with:
      * keyboard based navigation - Vim-inspired keybindings
      * Powerful search - Find anything instantly, highlight important passages, add bookmarks
      * Never lose your place - Automatic progress saving
      * Extensible workflows - Execute commands directly from copied text
      * Respects your privacy - Run locally without server, or selfhost the sync server
    '';
    homepage = "https://terminaltrove.com/hygg";
    downloadPage = "https://github.com/kruseio/hygg";
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.linux ++ [ "aarch64-darwin" ];
    maintainers = [ lib.maintainers.FKouhai ];
  };
})
