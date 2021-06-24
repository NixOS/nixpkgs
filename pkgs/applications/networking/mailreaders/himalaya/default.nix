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
  version = "0.2.6";

  src = fetchFromGitHub {
    owner = "soywod";
    repo = pname;
    rev = "v${version}";
    sha256 = "1fl3lingb4wdh6bz4calzbibixg44wnnwi1qh0js1ijp8b6ll560";
  };

  cargoSha256 = "10p8di71w7hn36b1994wgk33fnj641lsp80zmccinlg5fiwyzncx";

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

  # The completions are correctly installed, and there is issue that himalaya
  # generate empty completion files without mail configure.
  # This supposed to be fixed in 0.2.7
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
