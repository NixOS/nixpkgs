{
  rustPlatform,
  fetchFromGitHub,
  lib,
  installShellFiles,
  openssl,
  pkg-config,
  stdenv,
}:
rustPlatform.buildRustPackage rec {
  pname = "sentry-cli";
  version = "2.50.2";

  src = fetchFromGitHub {
    owner = "getsentry";
    repo = "sentry-cli";
    rev = version;
    hash = "sha256-hYJVfKoUZHfqKHqmF1lZyx5MDkILVsibYLLcb9TZ8yw=";
  };
  doCheck = false;

  # Needed to get openssl-sys to use pkgconfig.
  OPENSSL_NO_VENDOR = 1;

  buildInputs = [ openssl ];
  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  cargoHash = "sha256-yAZrjFGSeEA4A0tJZlvyHakbhlZT3gaE6HpKhJzHIFQ=";

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
