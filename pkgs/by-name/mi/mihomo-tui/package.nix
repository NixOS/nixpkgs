{
  lib,
  aws-lc,
  pkg-config,
  rustPlatform,
  fetchFromGitHub,
  cacert,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mihomo-tui";
  version = "0.6.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "potoo0";
    repo = "mihomo-tui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BpPLQVqt/vQGyE0YXbl0dRX6T1U33dz7UKywpflA+V0=";
  };

  cargoHash = "sha256-cOjvabLwCSNeGSxMT/iSqmeLZ3QpRYXNFLpmW6wmJ+0=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ aws-lc ];

  env = {
    # nixpkgs adds target-specific rustflags, which take precedence over
    # the build.rustflags in the upstream .cargo/config.toml.
    RUSTFLAGS = "--cfg tokio_unstable";

    # build.rs requires Git describe metadata to generate the --version information.
    VERGEN_GIT_DESCRIBE = "v${finalAttrs.version}";
    VERGEN_BUILD_DATE = "2026-11-14";
    VERGEN_DEFAULT_ON_ERROR = "1";
  };

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    cacert
  ];

  nativeInstallCheckInputs = [
    writableTmpDirAsHomeHook
    versionCheckHook
  ];
  # `--version` initializes the config directory and requires a writable home.
  versionCheckKeepEnvironment = [ "HOME" ];
  doInstallCheck = true;

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Simple TUI dashboard for monitoring and managing Mihomo via its REST API";
    homepage = "https://github.com/potoo0/mihomo-tui";
    changelog = "https://github.com/potoo0/mihomo-tui/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ potoo0 ];
    mainProgram = "mihomo-tui";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
