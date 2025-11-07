{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "iamb";
  version = "0.0.10";

  src = fetchFromGitHub {
    owner = "ulyssa";
    repo = "iamb";
    tag = "v${version}";
    hash = "sha256-cjBSWUBgfwdLnpneJ5XW2TdOFkNc+Rc/wyUp9arZzwg=";
  };

  cargoHash = "sha256-fAre0jrpJ63adcg4AKCYzdQtCsd0MMMcWA0RsoHo6ig=";

  nativeBuildInputs = [ installShellFiles ];

  preBuild = ''
    export HOME=$(mktemp -d)
  '';

  checkFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    # Attempted to create a NULL object.
    "--skip=base::tests::test_complete_cmdbar"
    "--skip=base::tests::test_complete_msgbar"

    # Attempted to create a NULL object.
    "--skip=windows::room::scrollback::tests::test_cursorpos"
    "--skip=windows::room::scrollback::tests::test_dirscroll"
    "--skip=windows::room::scrollback::tests::test_movement"
    "--skip=windows::room::scrollback::tests::test_search_messages"
  ];

  postInstall = ''
    installManPage $src/docs/iamb.{1,5}
    install -D $src/docs/iamb.svg -t $out/share/icons/hicolor/scalable/apps
    install -D $src/docs/iamb.metainfo.xml $out/share/appdata/chat.iamb.iamb.appdata.xml
    install -D $src/iamb.desktop -t $out/share/applications
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Matrix client for Vim addicts";
    mainProgram = "iamb";
    homepage = "https://github.com/ulyssa/iamb";
    changelog = "https://github.com/ulyssa/iamb/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ meain ];
  };
}
