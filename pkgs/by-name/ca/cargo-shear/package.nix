{
  fetchFromGitHub,
  lib,
  rustPlatform,
  testers,
  cargo-shear,
}:
let
  version = "1.1.8";
in
rustPlatform.buildRustPackage {
  pname = "cargo-shear";
  inherit version;

  src = fetchFromGitHub {
    owner = "Boshen";
    repo = "cargo-shear";
    rev = "v${version}";
    hash = "sha256-T05BSeVF67T7F6GMwsGDOYyiuz//0aTstTlGoOZndRM=";
  };

  cargoHash = "sha256-iV2hV57zuqnsDX0krtAADGvFo3YSCkiEm6+dNAz3W08=";

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
