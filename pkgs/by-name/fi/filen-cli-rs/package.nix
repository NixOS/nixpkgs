{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  writableTmpDirAsHomeHook,
  installShellFiles,
  sqlite,
  openssl,
  zstd,
  stdenv,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "filen-cli-rs";
  version = "0.3.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "FilenCloudDienste";
    repo = "filen-rs";
    tag = "filen-cli@v${finalAttrs.version}";
    hash = "sha256-vbtMe2I4p6V5/sXgB3VnxQ76EzwPHVM6Cc38jVgta9A=";
  };

  cargoHash = "sha256-CoJpGTkkoORjSLmn07A0UX1ZvR+m6VpzaIY2m/mGLjg=";

  buildAndTestSubdir = "filen-cli";

  __darwinAllowLocalNetworking = true;

  nativeBuildInputs = [
    pkg-config
    writableTmpDirAsHomeHook # Required to build shell completions
    installShellFiles
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
  };

  postInstall = ''
    mv "$out/bin/filen-cli" "$out/bin/filen"
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd filen \
      --bash <("$out/bin/filen" completions bash) \
      --fish <("$out/bin/filen" completions fish) \
      --zsh <("$out/bin/filen" completions zsh)
  '';

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
    broken = stdenv.hostPlatform.isDarwin; # https://github.com/NixOS/nixpkgs/pull/563557#issuecomment-7137833518
    description = "Tools for interacting with Filen cloud drive";
    homepage = "https://github.com/FilenCloudDienste/filen-rs";
    changelog = "https://github.com/FilenCloudDienste/filen-rs/blob/${finalAttrs.src.tag}/filen-cli/CHANGELOG.md";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      kachick
    ];
    mainProgram = "filen";
    platforms = with lib.platforms; unix ++ windows;
  };
})
