{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  sqlite,
  openssl,
  zstd,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "filen-cli-rs";
  version = "0.2.9";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "FilenCloudDienste";
    repo = "filen-rs";
    tag = "filen-cli@v${finalAttrs.version}";
    hash = "sha256-OIqutQawSjowKp08A2pbsSLxHOmPESEWHi3Y/E2v0/Q=";
  };

  cargoHash = "sha256-PNRj89hYOcBw1CsqWVn/HXtTQuz/afQq7ZwCzG7a16o=";

  buildAndTestSubdir = "filen-cli";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    sqlite
    openssl
    zstd
  ];

  env = {
    # Enable nightly features for higher-ranked-assumptions:
    # https://github.com/FilenCloudDienste/filen-rs/blob/29eb4bcd797229958dc0ef6ab12d9a8f8424b200/rust-toolchain.toml#L2
    RUSTC_BOOTSTRAP = true;

    # Upstream configures development-focused linker in .cargo/config.toml, but drops them in CD:
    # https://github.com/FilenCloudDienste/filen-rs/commit/29eb4bcd797229958dc0ef6ab12d9a8f8424b200
    RUSTFLAGS = "-Zhigher-ranked-assumptions";

    LIBSQLITE3_SYS_USE_PKG_CONFIG = true;
    OPENSSL_NO_VENDOR = true;
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  cargoTestFlags = [
    # Avoid tests under filen-cli/tests/ that require a real account
    "--lib"
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        # Prefer filen-cli-releases over filen-rs to get the version.
        # - filen-rs is a monorepo with too many other tags (filen-js@*) that hide the target tags (filen-cli@v*).
        #   We can revisit once https://github.com/Mic92/nix-update/issues/231 is resolved.
        # - filen-cli-releases often keeps new tags marked as pre-release after filen-rs releases, likely for real-world testing.
        "--url"
        "https://github.com/FilenCloudDienste/filen-cli-releases"
        "--use-github-releases"
      ];
    };
  };

  meta = {
    description = "Tools for interacting with Filen cloud drive";
    homepage = "https://github.com/FilenCloudDienste/filen-rs";
    changelog = "https://github.com/FilenCloudDienste/filen-rs/blob/${finalAttrs.src.tag}/filen-cli/CHANGELOG.md";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      kachick
    ];
    mainProgram = "filen-cli";
    platforms = with lib.platforms; unix ++ windows;
  };
})
