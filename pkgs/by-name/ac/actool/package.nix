{
  lib,
  fetchFromGitHub,
  rustPlatform,
  icu,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "actool";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "viraptor";
    repo = "actool";
    tag = finalAttrs.version;
    hash = "sha256-TRxA9c6q66Gso/ziqvly8IJR2AEHMc197gC9cUSuwAw=";
  };

  cargoHash = "sha256-BhR5gwIrFE0OuSAxVTY5kMfmMlPfIABfOgmX/rOvpug=";

  meta = {
    description = "Apple's actool reimplementation";
    homepage = "https://github.com/viraptor/actool";
    license = [ lib.licenses.mit ];
    mainProgram = "actool";
    maintainers = [ lib.maintainers.viraptor ];
  };
})
