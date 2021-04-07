{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, installShellFiles
, blas
, gfortran
, lapack
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "finalfusion-utils";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "finalfusion";
    repo = pname;
    rev = version;
    sha256 = "0gxcjrhfa86kz5qmdf5h278ydc3nc0nfj61brnykb723mg45jj41";
  };

  cargoSha256 = "03p786hh54zql61vhmsqcdgvz23v2rm12cgwf7clfmk6a6yj6ibx";

  # Enables build against a generic BLAS.
  cargoBuildFlags = [
    "--features"
    "netlib"
  ];

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = [
    blas
    gfortran.cc.lib
    lapack
  ] ++ lib.optionals stdenv.isDarwin [
    Security
  ];

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
    maintainers = with maintainers; [ danieldk ];
  };
}
