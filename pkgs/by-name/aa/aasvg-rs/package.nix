{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "aasvg-rs";
  version = "1.0.0";

  src = fetchCrate {
    inherit (finalAttrs) version;
    pname = "aasvg-cli";
    hash = "sha256-0qGCXHSCTg2yXLxREOfY7lOA3ZQCNFvST6GTBIsG/f4=";
  };

  cargoHash = "sha256-zl3IPKKG738cr1Au4Vw9SRstgOp57hM/JhPRNl0VsII=";

  meta = {
    description = "CLI tool to convert ASCII art diagrams to SVG";
    homepage = "https://github.com/bearcove/aasvg-rs";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ chillcicada ];
    mainProgram = "aasvg";
  };
})
