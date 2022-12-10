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
  version = "0.9.4";

  src = fetchFromGitHub {
    owner = "finalfusion";
    repo = pname;
    rev = version;
    sha256 = "1lvwv238p8hrl4sc5pmnvaargl2dd25p44gxl3kibq5ng03afd0n";
  };

  cargoSha256 = "0lhcazcih48gc23q484h344bzz7p3lh189ljhswdyph2i11caarp";

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

  meta = with lib; {
    description = "Utility for training word and subword embeddings";
    homepage = "https://github.com/finalfusion/finalfrontier/";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
