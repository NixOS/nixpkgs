{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  pkg-config,
  openssl,
  installShellFiles,
}:
rustPlatform.buildRustPackage rec {
  pname = "iggy-cli";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "iggy-rs";
    repo = "iggy";
    rev = "refs/tags/iggy-cli-${version}";
    hash = "sha256-GRmufkrwRjX7hC57mSKijbAswM0C6aYWrNwuFAIdtGY=";
  };

  cargoHash = "sha256-XNwfgKUXayIN88Zg/2yj+oyPSqbxuLofhiCay7B0SQE=";

  cargoBuildFlags = [
    "--bin"
    "iggy"
  ];

  cargoTestFlags = cargoBuildFlags;

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs = [ openssl ];

  OPENSSL_NO_VENDOR = 1;

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd iggy \
      --bash <($out/bin/iggy --generate bash) \
      --zsh <($out/bin/iggy --generate zsh) \
      --fish <($out/bin/iggy --generate fish)
  '';

  meta = {
    description = "CLI for Iggy message streaming platform";
    homepage = "https://github.com/iggy-rs/iggy";
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
