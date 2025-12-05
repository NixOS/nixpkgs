{
  makeWrapper,
  rustPlatform,
  pname,
  src,
  version,
}:
rustPlatform.buildRustPackage {
  pname = "${pname}-codelldb-launch";
  inherit version src;

  cargoHash = "sha256-fuUTLdavMiYfpyxctXes2GJCsNZd5g1d4B/v+W/Rnu8=";

  nativeBuildInputs = [ makeWrapper ];

  cargoBuildFlags = [
    "--package=codelldb-launch"
  ];

  # Tests fail to build (as of version 1.12.0).
  doCheck = false;
}
