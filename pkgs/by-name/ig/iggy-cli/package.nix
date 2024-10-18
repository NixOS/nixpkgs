{
  lib,
  rustPlatform,
  fetchCrate,
  stdenv,
  pkg-config,
  openssl,
  darwin,
  installShellFiles,
}:
rustPlatform.buildRustPackage rec {
  pname = "iggy-cli";
  version = "0.8.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-t0XFoy3AMAl7cpiTDxrUGgGm88UVsJaRcB9yDu3mPFo=";
  };

  cargoHash = "sha256-ltzC2lhedwlX/EuPg7OUeMWyntOriS5LutwRDbnHJAA=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs =
    [ openssl ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.Security
    ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd iggy \
      --bash <($out/bin/iggy --generate bash) \
      --zsh <($out/bin/iggy --generate zsh) \
      --fish <($out/bin/iggy --generate fish)
  '';

  meta = {
    description = "CLI for Iggy message streaming platform";
    homepage = "https://github.com/iggy-rs/iggy";
    changelog = "https://github.com/iggy-rs/iggy/commits/master/cli";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nartsiss ];
    platforms = [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-linux"
    ];
    mainProgram = "iggy";
  };
}
