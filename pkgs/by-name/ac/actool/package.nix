{
  lib,
  fetchFromGitHub,
  rustPlatform,
  icu,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "actool";
  version = "2.2.4";

  src = fetchFromGitHub {
    owner = "viraptor";
    repo = "actool";
    tag = finalAttrs.version;
    hash = "sha256-dDTa6J2by6uvg4gecwCcBIRGesZ1F0gAXSLr+6DYjGc=";
  };

  cargoHash = "sha256-Q0fSZNXw/71kMemYzwVsBRFcAMNl4ItKu56YdB0AAdM=";

  meta = {
    description = "Apple's actool reimplementation";
    homepage = "https://github.com/viraptor/actool";
    license = lib.licenses.mit;
    mainProgram = "actool";
    maintainers = [ lib.maintainers.viraptor ];
  };
})
