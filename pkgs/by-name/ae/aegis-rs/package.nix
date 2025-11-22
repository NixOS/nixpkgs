{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "aegis-rs";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "Granddave";
    repo = "aegis-rs";
    rev = "v${version}";
    hash = "sha256-/1HP7mGnJ+p6Gi3P8w/rYKrDPJ3ZGzhdFTxO1ArGsYM=";
  };

  cargoHash = "sha256-X3m4Sw0qj9VZlc3RJdXRDFiU/j1irm4K3BVlKzE3C2U=";

  meta = {
    description = "Aegis compatible OTP generator for the CLI";
    homepage = "https://github.com/Granddave/aegis-rs";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ granddave ];
    mainProgram = "aegis-rs";
  };
}
