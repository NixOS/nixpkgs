{ lib
, fetchFromGitHub
, rustPlatform
, pkg-config
, openssl
, stdenv
, installShellFiles
, libiconv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "novops";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "PierreBeucher";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Hqm3bKMRUyIZ/wD+kjAhUuKcJdaA8LT7bnourda6nuw=";
  };

  cargoHash = "sha256-ObbCJQw4DgUH1/XuI7ZgqFY9O9OH1uGUkfaQRjcGkAY=";

  buildInputs = [
    openssl # required for openssl-sys
  ] ++ lib.optional stdenv.hostPlatform.isDarwin [
    libiconv
    darwin.apple_sdk.frameworks.SystemConfiguration
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

  postInstall = ''
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
