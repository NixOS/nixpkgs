{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  protobuf,
  installShellFiles,
  writableTmpDirAsHomeHook,
}:

rustPlatform.buildRustPackage rec {
  pname = "clipcat";
  version = "0.24.0";

  src = fetchFromGitHub {
    owner = "xrelkd";
    repo = "clipcat";
    tag = "v${version}";
    hash = "sha256-EEM2gwr5j3umpZqHnxCO81EZbLQ3nYGcxb6DBJ7AbC8=";
  };

  cargoHash = "sha256-6fS/LnfNi3rH4H61GCdLp6pnfGPIXJiY2dAwKdK5ofk=";

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
}
