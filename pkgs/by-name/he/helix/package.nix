{
  fetchzip,
  lib,
  rustPlatform,
  git,
  installShellFiles,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "helix";
  version = "25.01";

  # This release tarball includes source code for the tree-sitter grammars,
  # which is not ordinarily part of the repository.
  src = fetchzip {
    url = "https://github.com/helix-editor/helix/releases/download/${version}/helix-${version}-source.tar.xz";
    hash = "sha256-HyDsHimDug+8vX0wfon4pK0DEYH5402CDinp3EZpaWs=";
    stripRoot = false;
  };

  cargoHash = "sha256-G3gJRI12JFk+A4DP65TOcD9jBJvNrb4aPr9V9uv4JP0=";

  nativeBuildInputs = [
    git
    installShellFiles
  ];

  env.HELIX_DEFAULT_RUNTIME = "${placeholder "out"}/lib/runtime";

  postInstall = ''
    # not needed at runtime
    rm -r runtime/grammars/sources

    mkdir -p $out/lib
    cp -r runtime $out/lib
    installShellCompletion contrib/completion/hx.{bash,fish,zsh}
    mkdir -p $out/share/{applications,icons/hicolor/256x256/apps}
    cp contrib/Helix.desktop $out/share/applications
    cp contrib/helix.png $out/share/icons/hicolor/256x256/apps
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  # `hx --version` outputs 25.1 instead of 25.01
  preVersionCheck = ''
    export version=${lib.replaceStrings [ ".0" ] [ "." ] version}
  '';
  versionCheckProgram = "${placeholder "out"}/bin/hx";
  versionCheckProgramArg = [ "--version" ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Post-modern modal text editor";
    homepage = "https://helix-editor.com";
    changelog = "https://github.com/helix-editor/helix/blob/${version}/CHANGELOG.md";
    license = lib.licenses.mpl20;
    mainProgram = "hx";
    maintainers = with lib.maintainers; [
      danth
      yusdacra
      zowoq
    ];
  };
}
