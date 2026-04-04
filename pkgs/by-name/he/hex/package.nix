{
  lib,
  rustPlatform,
  fetchFromGitHub,
  testers,
  hex,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hex";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "sitkevij";
    repo = "hex";
    rev = "v${finalAttrs.version}";
    hash = "sha256-YctXDhCMJvDQLPsuhzdyYDUIlFE2vKltNtrFFeE7YE8=";
  };

  cargoHash = "sha256-3lrNZyQVP+gswbF+pqQmVIHg3bjiJ22y87PtTHDwIXs=";

  passthru.tests.version = testers.testVersion {
    package = hex;
    version = "hx ${finalAttrs.version}";
  };

  meta = {
    description = "Futuristic take on hexdump, made in Rust";
    homepage = "https://github.com/sitkevij/hex";
    changelog = "https://github.com/sitkevij/hex/releases/tag/v${finalAttrs.version}";
    mainProgram = "hx";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
