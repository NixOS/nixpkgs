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
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "soywod";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-s2QZSusJLeo4WIorSj+e1yYqWXFqTt8YF6/Tyz9fHeY=";
  };

  cargoSha256 = "sha256-u9dLqr5CnrgYiDWAiW9u1zcUWmprOiq5+TfafO8M+WU=";

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
