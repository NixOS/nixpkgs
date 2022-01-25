{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, installShellFiles
, blas
, gfortran
, lapack
, openssl
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "finalfusion-utils";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "finalfusion";
    repo = pname;
    rev = version;
    sha256 = "sha256-suzivynlgk4VvDOC2dQR40n5IJHoJ736+ObdrM9dIqE=";
  };

  cargoSha256 = "sha256-HekjmctuzOWs5k/ihhsV8vVkm6906jEnFf3yvhkrA5Y=";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = [
    blas
    gfortran.cc.lib
    lapack
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    Security
  ];

  # Enables build against a generic BLAS.
  buildFeatures = [ "netlib" ];

  postInstall = ''
    # Install shell completions
    for shell in bash fish zsh; do
      $out/bin/finalfusion completions $shell > finalfusion.$shell
    done
    installShellCompletion finalfusion.{bash,fish,zsh}
  '';

  meta = with lib; {
    description = "Utility for converting, quantizing, and querying word embeddings";
    homepage = "https://github.com/finalfusion/finalfusion-utils/";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
