{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, openssl
, pkg-config
, installShellFiles
, enableCompletions ? stdenv.hostPlatform == stdenv.buildPlatform
, Security
, libiconv
}:
rustPlatform.buildRustPackage rec {
  pname = "himalaya";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "soywod";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-wiasnkoIU4l1yyhUSTahOJMCOyhpz2w4WJzi/UBmiHE=";
  };

  cargoSha256 = "sha256-VXSJLDpT0s+sh6buOP63QSiUp34H6G/FWibemtNU9wQ=";

  # use --lib flag to avoid test with imap server
  # https://github.com/soywod/himalaya/issues/145
  cargoTestFlags = [ "--lib" ];

  nativeBuildInputs = [ ]
    ++ lib.optionals (enableCompletions) [ installShellFiles ]
    ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [ pkg-config ];

  buildInputs =
    if stdenv.hostPlatform.isDarwin then [
      Security
      libiconv
    ] else [
      openssl
    ];

  postInstall = lib.optionalString enableCompletions ''
    # Install shell function
    installShellCompletion --cmd himalaya \
      --bash <($out/bin/himalaya completion bash) \
      --fish <($out/bin/himalaya completion fish) \
      --zsh <($out/bin/himalaya completion zsh)
  '';

  meta = with lib; {
    description = "CLI email client written in Rust";
    homepage = "https://github.com/soywod/himalaya";
    license = licenses.bsd3;
    maintainers = with maintainers; [ yanganto ];
  };
}
