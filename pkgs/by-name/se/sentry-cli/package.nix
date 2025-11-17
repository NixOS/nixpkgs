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
  replaceVars,
}:
rustPlatform.buildRustPackage rec {
  pname = "sentry-cli";
  version = "2.58.0";

  src = fetchFromGitHub {
    owner = "getsentry";
    repo = "sentry-cli";
    rev = version;
    hash = "sha256-8fz8bSQxqylTQ7mD/QbQ6gc8qlEdx/SDCjaB3uqFnGA=";
  };
  doCheck = false;

  # Needed to get openssl-sys to use pkgconfig.
  OPENSSL_NO_VENDOR = 1;

  patches = [
    (replaceVars ./fix-swift-lib-path.patch {
      swiftLib = lib.getLib swift;
    })
  ];

  buildInputs = [ openssl ];
  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ]
  ++ (lib.optionals stdenv.hostPlatform.isDarwin [
    swift
    swiftpm
  ]);

  # By default including `swiftpm` in `nativeBuildInputs` will take over `buildPhase`
  dontUseSwiftpmBuild = true;

  cargoHash = "sha256-3I0uKHpD4SpSeLSIAEjBxxAFfyS4WIvb76x7QAy53HM=";

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
