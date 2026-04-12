{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mhost";
  version = "0.11.3";

  src = fetchFromGitHub {
    owner = "lukaspustina";
    repo = "mhost";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-rBIHGwEN1RqfC3CuZn3sfCWGiV/vgtpmKzsxB4Er95U=";
  };

  cargoHash = "sha256-bmN7VYKlhSoVQ+y5/vcOc9J6eUGER2WFYMfV7OM/POM=";

  env.CARGO_CRATE_NAME = "mhost";

  doCheck = false;

  meta = {
    description = "Modern take on the classic host DNS lookup utility including an easy to use and very fast Rust lookup library";
    homepage = "https://github.com/lukaspustina/mhost";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = [ lib.maintainers.mgttlinger ];
    mainProgram = "mhost";
  };
})
