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
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "finalfusion";
    repo = pname;
    rev = version;
    sha256 = "sha256-ME0qDSFD8G492+7ex7VQWh9P76a+tOCo+SJ9n9ZIYUI=";
  };

  cargoSha256 = "sha256-/rLv2/bcVsmWw+ZfyumDcj0ptHPQBCCYR9O/lVlV+G0=";

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
    maintainers = with maintainers; [ ];
  };
}
