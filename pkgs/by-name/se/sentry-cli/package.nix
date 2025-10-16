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
}:
rustPlatform.buildRustPackage rec {
  pname = "sentry-cli";
  version = "2.56.1";

  src = fetchFromGitHub {
    owner = "getsentry";
    repo = "sentry-cli";
    rev = version;
    hash = "sha256-2T4HEWEcT8ehy5wQqKlBPx2MyusLYg8eM/fWlZ83HAw=";
  };
  doCheck = false;

  # Needed to get openssl-sys to use pkgconfig.
  OPENSSL_NO_VENDOR = 1;

  patches = [
    ./fix-swift-lib-path.patch
  ];

  buildInputs = [ openssl ];
  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ] ++ (lib.optionals stdenv.hostPlatform.isDarwin [
      swift
      swiftpm
      (writeShellScriptBin "xcode-select" ''
        echo $DEVELOPER_DIR
      '')
  ]);

  # By default including `swiftpm` in `nativeBuildInputs` will take over `buildPhase`
  dontUseSwiftpmBuild = true;

  cargoHash = "sha256-6AM1oGX4q6kHePiS0fsoXPt0b89O9WItIBukPIwapJQ=";

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
