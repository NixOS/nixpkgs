{
  stdenvNoCC,
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  versionCheckHook,
  writableTmpDirAsHomeHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "feedr";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "bahdotsh";
    repo = "feedr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5s4QgkUX27WNrTyzyYDQjf4VjKD0Kdkicjf7hlO9OKE=";
  };

  cargoHash = "sha256-3xSvqj2kW0lOFUzkAbBJThJx6u7f1tSk1qgFdm2tVfg=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  checkFlags = [
    # Those tests require network access, which is not available in the sandbox.
    # Error: Failed to parse RSS feed: Failed to fetch feed
    "--skip=test_mixed_feeds"
    "--skip=test_rss_feed_parsing"
  ]
  ++ lib.optionals stdenvNoCC.hostPlatform.isDarwin [
    # event loop thread panicked
    "--skip=test_problematic_feeds"
    "--skip=test_reddit_style_atom_feeds"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/bahdotsh/feedr/releases/tag/${finalAttrs.src.tag}";
    description = "Feature-rich terminal-based RSS/Atom feed reader written in Rust";
    longDescription = "Feedr is a modern terminal-based RSS/Atom feed reader with advanced filtering, categorization, and search capabilities. It supports both RSS and Atom feeds with compression handling and provides an intuitive TUI interface.";
    homepage = "https://github.com/bahdotsh/feedr";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drupol ];
    mainProgram = "feedr";
  };
})
