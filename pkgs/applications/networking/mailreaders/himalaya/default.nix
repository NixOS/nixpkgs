{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, installShellFiles
, installShellCompletions ? stdenv.hostPlatform == stdenv.buildPlatform
, installManPages ? stdenv.hostPlatform == stdenv.buildPlatform
, pkg-config
, Security
, libiconv
, openssl
}:

rustPlatform.buildRustPackage rec {
  pname = "himalaya";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "soywod";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-d+ERCUPUHx41HfBtjb6BjhGKzkUTGIb01BRWvAnLYwk=";
  };

  cargoSha256 = "sha256-ICaahkIP1uSm4iXvSPMo8uVTtSa1nCyJdDihGdVEQvg=";

  nativeBuildInputs = [ ]
    ++ lib.optionals (installManPages || installShellCompletions) [ installShellFiles ]
    ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [ pkg-config ];

  buildInputs =
    if stdenv.hostPlatform.isDarwin then [
      Security
      libiconv
    ] else [
      openssl
    ];

  # flag added because without end-to-end testing is ran which requires
  # additional tooling and servers to test
  cargoTestFlags = [ "--lib" ];


  postInstall = lib.optionalString installManPages ''
    # Install man pages
    mkdir -p $out/man
    $out/bin/himalaya man $out/man
    installManPage $out/man/*
  '' ++ lib.optionalString installShellCompletions ''
    # Install shell completions
    installShellCompletion --cmd himalaya \
      --bash <($out/bin/himalaya completion bash) \
      --fish <($out/bin/himalaya completion fish) \
      --zsh <($out/bin/himalaya completion zsh)
  '';

  meta = with lib; {
    description = "Command-line interface for email management";
    homepage = "https://github.com/soywod/himalaya";
    changelog = "https://github.com/soywod/himalaya/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ soywod toastal yanganto ];
  };
}
