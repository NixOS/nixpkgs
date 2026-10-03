{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mihomo-tui";
  version = "0.4.5";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "potoo0";
    repo = "mihomo-tui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tNeH4HnpUL6UipDtSTfQLcT0ruwkUkho5+M6Mlj5E4c=";
  };

  cargoHash = "sha256-JOa5otMJE1GqpGnsIvY/O4ps0N3N1wpepESigY0+Dic=";

  env = {
    # nixpkgs adds target-specific rustflags, which take precedence over
    # the build.rustflags in the upstream .cargo/config.toml.
    RUSTFLAGS = "--cfg tokio_unstable";

    # build.rs requires Git describe metadata to generate the --version information.
    VERGEN_GIT_DESCRIBE = "v${finalAttrs.version}";
    VERGEN_BUILD_DATE = "2026-07-19";
    VERGEN_DEFAULT_ON_ERROR = "1";
  };

  nativeInstallCheckInputs = [
    writableTmpDirAsHomeHook
    versionCheckHook
  ];
  # `--version` initializes the config directory and requires a writable home.
  versionCheckKeepEnvironment = [ "HOME" ];
  doInstallCheck = true;

  passthru.updateScript = ./update.sh;

  meta = {
    description = "A simple TUI dashboard for monitoring and managing Mihomo via its REST API";
    homepage = "https://github.com/potoo0/mihomo-tui";
    changelog = "https://github.com/potoo0/mihomo-tui/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ potoo0 ];
    mainProgram = "mihomo-tui";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
