{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  blas,
  gfortran,
  lapack,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "finalfusion-utils";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "finalfusion";
    repo = "finalfusion-utils";
    rev = version;
    sha256 = "sha256-suzivynlgk4VvDOC2dQR40n5IJHoJ736+ObdrM9dIqE=";
  };

  cargoHash = "sha256-X8ENEtjH1RHU2+VwtkHsyVYK37O8doMlLk94O2BGqy0=";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = [
    blas
    gfortran.cc.lib
    lapack
    openssl
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
    maintainers = [ ];
    mainProgram = "finalfusion";
  };
}
