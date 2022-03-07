{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, enableCompletions ? stdenv.hostPlatform == stdenv.buildPlatform
, installShellFiles
, pkg-config
, Security
, libiconv
, openssl
}:

rustPlatform.buildRustPackage rec {
  pname = "himalaya";
  version = "0.5.8";

  src = fetchFromGitHub {
    owner = "soywod";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Ejaspj0YpkGmfO1omOhx8ZDg77J7NqC32mw5Cd3K1FM=";
  };

  cargoSha256 = "sha256-xce2iHrqTxIirrut4dN7526pjE4T+ruaDS44jr+KeGs=";

  nativeBuildInputs = lib.optionals enableCompletions [ installShellFiles ]
    ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [ pkg-config ];

  buildInputs =
    if stdenv.hostPlatform.isDarwin then [
      Security
      libiconv
    ] else [
      openssl
    ];

  cargoTestFlags = [ "--lib" ];

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
    changelog = "https://github.com/soywod/himalaya/blob/v${version}/CHANGELOG.md";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ yanganto ];
  };
}
