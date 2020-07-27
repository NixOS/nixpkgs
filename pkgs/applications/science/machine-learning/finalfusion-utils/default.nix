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
  version = "0.11.2";

  src = fetchFromGitHub {
    owner = "finalfusion";
    repo = pname;
    rev = version;
    sha256 = "1y2ik3qj2wbjnnk7bbglwbvyvbm5zfk7mbd1gpxg4495nzlf2jhf";
  };

  cargoSha256 = "19yay31f76ns1d6b6k9mgw5mrl8zg69y229ca6ssyb2z82gyhsnw";

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

  meta = with stdenv.lib; {
    description = "Utility for converting, quantizing, and querying word embeddings";
    homepage = "https://github.com/finalfusion/finalfusion-utils/";
    license = licenses.asl20;
    maintainers = with maintainers; [ danieldk ];
    platforms = platforms.all;
  };
}
