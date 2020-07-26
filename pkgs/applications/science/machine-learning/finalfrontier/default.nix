{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, installShellFiles
, pkg-config
, libiconv
, openssl
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "finalfrontier";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "finalfusion";
    repo = pname;
    rev = version;
    sha256 = "1mb8m1iabaikjc1kn8n6z3zlp50gxm5dgpfvhh9pc4ys63ymcy09";
  };

  cargoSha256 = "138dlqjza98x1m6igi4xkyypl0mfplvzkqk63bbna0vkma8y66gw";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [
    libiconv
    Security
  ];

  postInstall = ''
    installManPage man/*.1

    # Install shell completions
    for shell in bash fish zsh; do
      $out/bin/finalfrontier completions $shell > finalfrontier.$shell
    done
    installShellCompletion finalfrontier.{bash,fish,zsh}
  '';

  meta = with stdenv.lib; {
    description = "Utility for training word and subword embeddings";
    homepage = "https://github.com/finalfusion/finalfrontier/";
    license = licenses.asl20;
    maintainers = with maintainers; [ danieldk ];
    platforms = platforms.all;
  };
}
