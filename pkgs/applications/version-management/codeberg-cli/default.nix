{ lib
, CoreServices
, Security
, fetchFromGitea
, installShellFiles
, openssl
, pkg-config
, rustPlatform
, stdenv
}:
rustPlatform.buildRustPackage rec {
  pname = "codeberg-cli";
  version = "0.3.5";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "RobWalt";
    repo = "codeberg-cli";
    rev = "v${version}";
    hash = "sha256-KjH78yqfZoN24TBYyFZuxf7z9poRov0uFYQ8+eq9p/o=";
  };

  cargoHash = "sha256-RE4Zwa5vUWPc42w5GaaYkS6fLIbges1fAsOUuwqR2ag=";
  nativeBuildInputs = [ pkg-config installShellFiles ];

  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ CoreServices Security ];

  postInstall = ''
    installShellCompletion --cmd berg \
      --bash <($out/bin/berg completion bash) \
      --fish <($out/bin/berg completion fish) \
      --zsh <($out/bin/berg completion zsh)
  '';

  meta = with lib; {
    description = "CLI Tool for Codeberg similar to gh and glab";
    homepage = "https://codeberg.org/RobWalt/codeberg-cli";
    license = with licenses; [ agpl3Plus ];
    maintainers = with maintainers; [ robwalt ];
    mainProgram = "berg";
  };
}
