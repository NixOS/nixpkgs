{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mhost";
  version = "0.11.4";

  src = fetchFromGitHub {
    owner = "lukaspustina";
    repo = "mhost";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-5LSgPFozTPItTLD1WVcLPGycjxjMOoY4U6eiD49hEdE=";
  };

  cargoHash = "sha256-PO4d1OosHhbFuPQSI8yZNaVQ2tAcFONAso+p+Qq8wTg=";

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
