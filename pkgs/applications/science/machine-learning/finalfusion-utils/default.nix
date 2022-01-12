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
  version = "0.13.2";

  src = fetchFromGitHub {
    owner = "finalfusion";
    repo = pname;
    rev = version;
    sha256 = "sha256-Wv3K2G542e1bKuJB+dZi0SW4dbopvs7SBohv+zgi5MI=";
  };

  cargoSha256 = "sha256-oI7bq/yEXP7aMLWGKAecyq1lqq7ZbHtwxX2ldZMFY8I=";

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
