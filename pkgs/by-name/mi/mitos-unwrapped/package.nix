{
  lib,
  rustPlatform,
  fetchFromGitHub,
  runCommand,
  installShellFiles,
  copyDesktopItems,
  git,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (
  finalAttrs:
  let
    # copy only runtime/ to keep the source out of the closure
    defaultRuntimeDir = runCommand "mitos-default-runtime" { } ''
      cp -r --no-preserve=mode ${finalAttrs.src}/runtime $out
      rm -rf $out/grammars
    '';
  in
  {
    pname = "mitos-unwrapped";
    version = "0.1.2";

    __structuredAttrs = true;

    src = fetchFromGitHub {
      owner = "mitos-editor";
      repo = "mitos";
      tag = "v${finalAttrs.version}";
      hash = "sha256-L8vv/yVT4Vrh1BDddNniiRk5zDIWAMxqgxUmSCC/d0U=";
    };

    cargoHash = "sha256-KDC0/LMmGxdqkFQbvQL7UVSFW8tsCHA/UA8+W2tYR50=";

    nativeBuildInputs = [
      installShellFiles
      copyDesktopItems
    ];
    nativeCheckInputs = [ git ];
    useNextest = true;

    env = {
      # don't fetch grammars in build.rs
      MITOS_DISABLE_AUTO_GRAMMAR_BUILD = "1";
      MITOS_DEFAULT_RUNTIME = defaultRuntimeDir;
    };

    desktopItems = [ "${finalAttrs.src}/contrib/Mitos.desktop" ];

    postInstall = ''
      installShellCompletion contrib/completion/ms.{bash,fish,zsh}
    '';

    nativeInstallCheckInputs = [ versionCheckHook ];
    doInstallCheck = true;

    meta = {
      description = "Fast and minimal modal text editor, forked from Helix";
      homepage = "https://github.com/mitos-editor/mitos";
      changelog = "https://github.com/mitos-editor/mitos/blob/v${finalAttrs.version}/CHANGELOG.md";
      license = lib.licenses.mpl20;
      mainProgram = "ms";
      maintainers = with lib.maintainers; [ giomf ];
    };
  }
)
