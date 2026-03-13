{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ifrextractor-rs";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "LongSoft";
    repo = "ifrextractor-rs";
    rev = "v${finalAttrs.version}";
    hash = "sha256-zpoOThjkL2Hu/ytxdqWcr2GXzN4Cm8hph7PJhSF5BlU=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  meta = {
    description = "Rust utility to extract UEFI IFR data into human-readable text";
    mainProgram = "ifrextractor";
    homepage = "https://github.com/LongSoft/IFRExtractor-RS";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ jiegec ];
  };
})
