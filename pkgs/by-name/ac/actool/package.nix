{
  lib,
  fetchFromGitHub,
  rustPlatform,
  icu,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "actool";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "viraptor";
    repo = "actool";
    tag = finalAttrs.version;
    hash = "sha256-+KSJo9kWvgaDkH+09oWDuQaljm78LeULVomu7xVwLak=";
  };

  cargoHash = "sha256-wpoPWQAxb/LN4EuLx1d5XrRgr1iP2mfbRyS3zb7C66k=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Apple's actool reimplementation";
    homepage = "https://github.com/viraptor/actool";
    license = [ lib.licenses.mit ];
    mainProgram = "actool";
    maintainers = [ lib.maintainers.viraptor ];
  };
})
