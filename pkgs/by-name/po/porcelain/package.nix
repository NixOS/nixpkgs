{
  lib,
  rustPlatform,
  fetchFromGitea,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "porcelain";
  version = "0.1.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "da157";
    repo = "porcelain";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Ghca4HLjz+GcCyxpl4MxRlaknL1g/mxW/riUBwyVzqU=";
  };

  cargoHash = "sha256-aWVBx/VPlRTBDMdUwpgsztH82vXdtc3Gulcnbz2tGNI=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI dollcode encoder and decoder";
    homepage = "https://codeberg.org/da157/porcelain";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.da157 ];
    mainProgram = "porcelain";
  };
})
