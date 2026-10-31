{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mihomo-tui";
  version = "0.6.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "potoo0";
    repo = "mihomo-tui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-w0W0J/SsEw6go5eRcLzEbGTh4JMxlp4pWjrTddFfpvc=";
  };

  cargoHash = "sha256-wHuf+dlqAsD63gJH44w6r3+sPMJdFYxSReuqW8NCyng=";

  env = {
    # nixpkgs adds target-specific rustflags, which take precedence over
    # the build.rustflags in the upstream .cargo/config.toml.
    RUSTFLAGS = "--cfg tokio_unstable";

    # build.rs requires Git describe metadata to generate the --version information.
    VERGEN_GIT_DESCRIBE = "v${finalAttrs.version}";
    VERGEN_BUILD_DATE = "2026-10-31";
    VERGEN_DEFAULT_ON_ERROR = "1";
  };

  __darwinAllowLocalNetworking = true;

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
