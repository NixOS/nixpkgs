{
  fetchFromGitHub,
  lib,
  nix-update-script,
  openssl,
  pkg-config,
  rust-jemalloc-sys,
  rustPlatform,
  sqlite,
  stdenv,
  versionCheckHook,
  zstd,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "spider";
  version = "2.34.2";

  src = fetchFromGitHub {
    owner = "spider-rs";
    repo = "spider";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3KEOzrIFizVBZRI1pD1PeNVj1IiV3ImucW77qHJhDM8=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-Hn9rQ9yv7vekmtGWorETK1b5rdfW0M/88Q6IvH51oE0=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    openssl
    rust-jemalloc-sys
    sqlite
    zstd
  ];

  env = {
    OPENSSL_NO_VENDOR = true;
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  checkFlags =
    [
      # Sandbox limitation: no network or io_uring
      "--skip=website::crawl"
      "--skip=website::scrape"
      "--skip=website::test_crawl_subdomains"
      "--skip=website::test_crawl_tld"
      "--skip=website::test_respect_robots_txt"
      "--skip=page::parse_links"
      "--skip=page::test_status_code"
      "--skip=pdl_is_fresh"
      "--skip=verify_revision_available"
    ]
    ++ lib.optionals stdenv.isDarwin [
      # Sandbox limitation: attempted to create a NULL object
      "--skip=website::test_link_duplicates"
      "--skip=website::not_crawl_blacklist"
      "--skip=website::test_crawl_budget"
      "--skip=website::test_crawl_subscription"
      "--skip=website::Website::subscribe_guard"
      "--skip=website::Website::subscribe"
    ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/spider-rs/spider/releases/tag/v${finalAttrs.version}";
    description = "Web crawler and scraper, building blocks for data curation workloads";
    homepage = "https://github.com/spider-rs/spider";
    license = lib.licenses.mit;
    mainProgram = "spider";
    maintainers = with lib.maintainers; [
      j-mendez
      KSJ2000
    ];
    platforms = lib.platforms.unix;
  };
})
