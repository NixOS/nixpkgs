{
  lib,
  rustPlatform,
  fetchFromGitHub,
  testers,
  hex,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hex";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "sitkevij";
    repo = "hex";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Q/h6mIjEErrDY/jJUyldd8TaNlk4Zn770ToHicP2+Ng=";
  };

  cargoHash = "sha256-t+ALA1yhaLOl8gdJRo0jgNBPv8xZ0QriNLcn9L0QxyA=";

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
