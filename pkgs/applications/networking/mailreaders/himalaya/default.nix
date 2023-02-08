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
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "soywod";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-qwtG6pk/PCr5lAcxRt1D8XM3rUG1bEVrUFo+3tMPlRw=";
  };

  cargoSha256 = "sha256-Jg/sVluw7UoBEYGk/A5Q5Qr8EojxEpr/E/F1caN7ZG8=";

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

  # TODO: is there a way to spawn an IMAP server to run integration
  # tests?
  cargoTestFlags = [ "--lib" ];

  postInstall = lib.optionalString installManPages ''
    # Install man pages
    mkdir -p $out/man
    $out/bin/himalaya man $out/man
    installManPage $out/man/*
  '' + lib.optionalString installShellCompletions ''
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
