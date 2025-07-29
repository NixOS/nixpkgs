{
  lib,
  cmake,
  fetchFromGitHub,
  rustPlatform,
  testers,
}:

let
  pname = "amazon-qldb-shell";
  version = "2.0.1";
  package = rustPlatform.buildRustPackage {
    inherit pname version;

    src = fetchFromGitHub {
      owner = "awslabs";
      repo = "amazon-qldb-shell";
      tag = "v${version}";
      sha256 = "sha256-aXScqJ1LijMSAy9YkS5QyXtTqxd19lLt3BbyVXlbw8o=";
    };

    nativeBuildInputs = [
      cmake
      rustPlatform.bindgenHook
    ];

    cargoHash = "sha256-tD35Py81QLDVlBahYzgskOQK5lQW03xuCnUwVUi4oLU=";

    passthru.tests.version = testers.testVersion { inherit package; };

    meta = with lib; {
      description = "Interface to send PartiQL statements to Amazon Quantum Ledger Database (QLDB)";
      homepage = "https://github.com/awslabs/amazon-qldb-shell";
      license = licenses.asl20;
      maintainers = [ maintainers.terlar ];
      mainProgram = "qldb";
      # See https://hydra.nixos.org/build/255146098/log.
      broken = true; # Added 2024-04-06
    };
  };
in
package
