{
  makeWrapper,
  rustPlatform,
  pname,
  src,
  version,

  cargoHash,
}:
rustPlatform.buildRustPackage {
  pname = "${pname}-codelldb-types";
  inherit version src cargoHash;

  nativeBuildInputs = [ makeWrapper ];

  cargoBuildFlags = [
    "--package=codelldb-types"
  ];

  # Tests fail to build (as of version 1.12.0).
  doCheck = false;
}
