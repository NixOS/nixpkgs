{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  stdenv,
  installShellFiles,
  libiconv,
}:

rustPlatform.buildRustPackage rec {
  pname = "novops";
  version = "0.20.1";

  src = fetchFromGitHub {
    owner = "PierreBeucher";
    repo = "novops";
    rev = "v${version}";
    hash = "sha256-F3MtDTaeLoI54/xbbIU61hb+qLDn2u4lRv+3kU5c/D0=";
  };

  cargoHash = "sha256-F+JIAHk28qpJy97aQQup1Ss5G1p4LQzkj1ptjBhp1CY=";

  buildInputs = [
    openssl # required for openssl-sys
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  nativeBuildInputs = [
    installShellFiles
    pkg-config # required for openssl-sys
  ];

  cargoTestFlags = [
    # Only run lib tests (unit tests)
    # All other tests are integration tests which should not be run with Nix build
    "--lib"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd novops \
      --bash <($out/bin/novops completion bash) \
      --fish <($out/bin/novops completion fish) \
      --zsh <($out/bin/novops completion zsh)
  '';

  meta = with lib; {
    description = "Cross-platform secret & config manager for development and CI environments";
    homepage = "https://github.com/PierreBeucher/novops";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ pbeucher ];
    mainProgram = "novops";
  };
}
