{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "ifrextractor-rs";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "LongSoft";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-zpoOThjkL2Hu/ytxdqWcr2GXzN4Cm8hph7PJhSF5BlU=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  meta = with lib; {
    description = "Rust utility to extract UEFI IFR data into human-readable text";
    homepage = "https://github.com/LongSoft/IFRExtractor-RS";
    license = licenses.bsd2;
    maintainers = with maintainers; [ jiegec ];
  };
}
