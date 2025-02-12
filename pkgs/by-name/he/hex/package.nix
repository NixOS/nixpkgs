{
  lib,
  rustPlatform,
  fetchFromGitHub,
  testers,
  hex,
}:

rustPlatform.buildRustPackage rec {
  pname = "hex";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "sitkevij";
    repo = "hex";
    rev = "v${version}";
    hash = "sha256-YctXDhCMJvDQLPsuhzdyYDUIlFE2vKltNtrFFeE7YE8=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-3lrNZyQVP+gswbF+pqQmVIHg3bjiJ22y87PtTHDwIXs=";

  passthru.tests.version = testers.testVersion {
    package = hex;
    version = "hx ${version}";
  };

  meta = with lib; {
    description = "Futuristic take on hexdump, made in Rust";
    homepage = "https://github.com/sitkevij/hex";
    changelog = "https://github.com/sitkevij/hex/releases/tag/v${version}";
    mainProgram = "hx";
    license = licenses.mit;
    maintainers = [ ];
  };
}
