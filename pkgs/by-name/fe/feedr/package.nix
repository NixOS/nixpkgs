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
  version = "0.8.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "bahdotsh";
    repo = "feedr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-x8FypbvuAzARc/Jy9kSfSVSSVUsTTdLJU9ihNWpUbak=";
  };

  cargoHash = "sha256-bUZnaAKlbNCOoMYufBZSHu2QLtxsrur3Cdmpd5y4Sw8=";

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
    "--skip=test_extract_article_rejects_non_http_scheme"
    # bind 127.0.0.1: Os { code: 1, kind: PermissionDenied, message: "Operation not permitted" }
    "--skip=test_extract_article_rejects_non_html_content_type"
    "--skip=test_extract_article_follows_safe_redirect_to_public_target"
    "--skip=test_extract_article_does_not_send_authorization_header"
    "--skip=test_extract_article_rejects_oversized_content_length"
    "--skip=test_extract_article_rejects_redirect_into_private_ip_via_safe_client"
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
