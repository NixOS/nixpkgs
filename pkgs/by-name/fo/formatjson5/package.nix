{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "formatjson5";
  version = "0.2.6";

  src = fetchFromGitHub {
    owner = "google";
    repo = "json5format";
    # Not tagged, see Cargo.toml.
    rev = "056829990bab4ddc78c65a0b45215708c91b8628";
    hash = "sha256-Lredw/Fez+2U2++ShZcKTFCv8Qpai9YUvqvpGjG5W0o=";
  };

  cargoHash = "sha256-zPgaZPDyNVPmBXz6QwOYnmh/sbJ8aPST8znLMfIWejk=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  cargoBuildFlags = [
    "--example formatjson5"
  ];

  postInstall =
    let
      cargoTarget = rustPlatform.cargoInstallHook.targetSubdirectory;
    in
    ''
      install -D target/${cargoTarget}/release/examples/formatjson5 $out/bin/formatjson5
    '';

  meta = {
    description = "JSON5 formatter";
    homepage = "https://github.com/google/json5format";
    license = lib.licenses.bsd3;
    mainProgram = "formatjson5";
    maintainers = with lib.maintainers; [ katexochen ];
  };
}
