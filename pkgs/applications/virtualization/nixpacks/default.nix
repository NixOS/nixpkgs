{ lib, rustPlatform, fetchFromGitHub, clippy }:

rustPlatform.buildRustPackage rec {
  pname = "nixpacks";
  version = "v0.1.7";
  doCheck = true;
  cargoSha256 = "lEoCROgmRqcueQby4vR5GJOrQxCrjF3bBNeHsPmrAUk=";
  nativeBuildInputs = [ clippy ];
  src = fetchFromGitHub {
    owner = "railwayapp";
    repo = pname;
    rev = version;
    sha256 = "";
  };
  # skip `cargo test` due tests FHS dependency
  checkPhase = ''
    runHook preCheck
    cargo check
    cargo clippy
    runHook postCheck
  '';
  meta = with lib; {
    description = "App source + Nix packages + Docker = Image Resources";
    homepage = "https://github.com/railwayapp/nixpacks";
    license = licenses.mit;
    maintainers = [ maintainers.zoedsoupe ];
  };
}
