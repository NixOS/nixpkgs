{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  stdenv,
  installShellFiles,
  libiconv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "novops";
  version = "0.19.0";

  src = fetchFromGitHub {
    owner = "PierreBeucher";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-bpv8Ybrsb2CAV8Qxj69F2E/mekYsOuAiZWuDNHDtxw0=";
  };

  cargoHash = "sha256-5NKgGX4j2hQuP9/9OnABLXcWuTPMAfvX0oquoSXeEIE=";

  buildInputs =
    [
      openssl # required for openssl-sys
    ]
    ++ lib.optional stdenv.hostPlatform.isDarwin [
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
