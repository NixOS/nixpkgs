{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  rustPlatform,
  protobuf,
  installShellFiles,
  writableTmpDirAsHomeHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "clipcat";
  version = "0.26.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "xrelkd";
    repo = "clipcat";
    tag = "v${finalAttrs.version}";
    hash = "sha256-M7B6QLyABsGoy6dbKsCx1AKEfEoDhkY/cbzGbk59TiU=";
  };

  patches = [
    # Remove lints that were removed in rustc 1.99,
    # which fails the build with `renamed_and_removed_lints = "deny"`
    (fetchpatch {
      name = "drop-removed-lint.patch";
      url = "https://github.com/xrelkd/clipcat/commit/9761d95bfa267cb1c5b28ac27c4b63572b915f04.patch";
      hash = "sha256-ODpwBAtSCDM6M9WCxWvpl/P2DyJPNQnPj8MNEXJbbCQ=";
    })
    (fetchpatch {
      name = "remove-deprecated-linter-options.patch";
      url = "https://github.com/xrelkd/clipcat/commit/424fcef2d4e98a256d2897a2e901a9f7d28f0fd6.patch";
      hash = "sha256-YiH0oHiEhJvfzeS6FOC+2rpCHpPXVIY0dE6vkpwicSw=";
    })
  ];

  cargoHash = "sha256-YYlNH95A2aGVWd0vw2vmTMXTA3ornCBHbcFrg59uh3I=";

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
