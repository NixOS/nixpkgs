{
  rustPlatform,
  fetchFromGitHub,
  lib,
  installShellFiles,
  openssl,
  pkg-config,
  stdenv,
  swift,
  swiftpm,
  writeShellScriptBin,
  darwin,
}:
let
  # TODO: This should probably be in the `darwin` package set.
  xcode-select = writeShellScriptBin "xcode-select" ''
    echo ${darwin.xcode}/Contents/Developer
  '';
in
rustPlatform.buildRustPackage (
   rec {
    pname = "sentry-cli";
    version = "2.55.0";

    src = fetchFromGitHub {
      owner = "getsentry";
      repo = "sentry-cli";
      rev = version;
      hash = "sha256-QOYk/WT/4rOjNMU4h22+Lbl9X6Ezw1oBE5yVZZwLNo4=";
    };
    doCheck = false;

    # `build.rs` wants to run a Swift build 😩
    postPatch = lib.optionalString stdenv.isDarwin ''
      substituteInPlace \
        apple-catalog-parsing/native/swift/AssetCatalogParser/Package.swift \
        --replace-fail "// swift-tools-version: 5.10" \
                       "// swift-tools-version: 5.8"

    '';

    # Needed to get openssl-sys to use pkgconfig.
    OPENSSL_NO_VENDOR = 1;

    buildInputs = [ openssl ];
    nativeBuildInputs = [
      installShellFiles
      pkg-config
    ]
    ++ lib.optionals stdenv.isDarwin [
      swift
      swiftpm
      xcode-select
    ];

    cargoHash = "sha256-8OIBIMlR0XAhJrYNd0gtBhApuZF6r2+7iHrATQdMfr0=";

    postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      installShellCompletion --cmd sentry-cli \
          --bash <($out/bin/sentry-cli completions bash) \
          --fish <($out/bin/sentry-cli completions fish) \
          --zsh <($out/bin/sentry-cli completions zsh)
    '';

    meta = {
      homepage = "https://docs.sentry.io/cli/";
      license = lib.licenses.bsd3;
      description = "Command line utility to work with Sentry";
      mainProgram = "sentry-cli";
      changelog = "https://github.com/getsentry/sentry-cli/raw/${version}/CHANGELOG.md";
      maintainers = with lib.maintainers; [ rizary ];
    };
  }
  // lib.optionalAttrs stdenv.isDarwin {
    # Disable the `swiftpm` `setupHook`.
    dontUseSwiftpmBuild = true;
    dontUseSwiftpmCheck = true;
  }
)
