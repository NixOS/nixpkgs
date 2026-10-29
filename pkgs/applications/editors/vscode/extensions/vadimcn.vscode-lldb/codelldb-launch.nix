{
  makeBinaryWrapper,
  rustPlatform,
  pname,
  src,
  version,

  cargoHash,
}:
rustPlatform.buildRustPackage {
  pname = "${pname}-codelldb-launch";
  inherit version src cargoHash;

  nativeBuildInputs = [ makeBinaryWrapper ];

  cargoBuildFlags = [
    "--package=codelldb-launch"
  ];

  # Tests fail to build (as of version 1.12.0).
  doCheck = false;
}
