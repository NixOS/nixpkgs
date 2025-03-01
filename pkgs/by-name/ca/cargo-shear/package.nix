{
  fetchFromGitHub,
  lib,
  rustPlatform,
  testers,
  cargo-shear,
}:
let
  version = "1.1.9";
in
rustPlatform.buildRustPackage {
  pname = "cargo-shear";
  inherit version;

  src = fetchFromGitHub {
    owner = "Boshen";
    repo = "cargo-shear";
    rev = "v${version}";
    hash = "sha256-+FScGNBLEHO12i4szKqIU+8eYQHz3m16FeoYIuT5XDo=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-6qHUbfx3ej8Srp/BivuLXjQKZcCN1mNOi+aVa0Q7wtY=";

  # https://github.com/Boshen/cargo-shear/blob/a0535415a3ea94c86642f39f343f91af5cdc3829/src/lib.rs#L20-L23
  SHEAR_VERSION = version;
  passthru.tests.version = testers.testVersion {
    package = cargo-shear;
  };

  meta = {
    description = "Detect and remove unused dependencies from Cargo.toml";
    mainProgram = "cargo-shear";
    homepage = "https://github.com/Boshen/cargo-shear";
    changelog = "https://github.com/Boshen/cargo-shear/blob/v${version}/CHANGELOG.md";
    license = [ lib.licenses.mit ];
    maintainers = with lib.maintainers; [ uncenter ];
  };
}
