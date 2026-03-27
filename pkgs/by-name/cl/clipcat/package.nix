{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  protobuf,
  installShellFiles,
  writableTmpDirAsHomeHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "clipcat";
  version = "0.24.1";

  src = fetchFromGitHub {
    owner = "xrelkd";
    repo = "clipcat";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MbbrkXbXMxWh4fwWg5cIA9Hdibo1qZU7fv5h2oe8KOs=";
  };

  cargoHash = "sha256-cJK3ZBlVvd+coDsVwux2qUD0JQadjtJ7ToNcrpYHXZ4=";

  nativeBuildInputs = [
    protobuf
    installShellFiles
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # fix following error on darwin:
    # objc/notify.h:1:9: fatal error: could not build module 'Cocoa'
    writableTmpDirAsHomeHook
  ];

  checkFlags = [
    # Some test cases interact with X11, skip them
    "--skip=test_x11_clipboard"
    "--skip=test_x11_primary"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    for cmd in clipcatd clipcatctl clipcat-menu clipcat-notify; do
      installShellCompletion --cmd $cmd \
        --bash <($out/bin/$cmd completions bash) \
        --fish <($out/bin/$cmd completions fish) \
        --zsh  <($out/bin/$cmd completions zsh)
    done
  '';

  meta = {
    description = "Clipboard Manager written in Rust Programming Language";
    homepage = "https://github.com/xrelkd/clipcat";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [
      xrelkd
      bot-wxt1221
    ];
    mainProgram = "clipcatd";
  };
})
