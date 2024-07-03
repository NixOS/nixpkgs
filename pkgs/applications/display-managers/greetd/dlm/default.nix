{ lib
, rustPlatform
, fetchFromSourcehut
}:

rustPlatform.buildRustPackage rec {
  pname = "dlm";
  version = "2020-01-07";

  src = fetchFromSourcehut {
    owner = "~kennylevinsen";
    repo = "dlm";
    rev = "6b0e11c4f453b1a4d7a32019227539a980b7ce66";
    hash = "sha256-V5Be3JJXOFiMEqf7Iy9U8inLUZfb4hOG8mKPB3w9fOQ=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "greet_proto-0.2.0" = "sha256-91TsxEvMfVGpPIS9slHP1YHM2DKxpO4v/CP5iGphIyY=";
    };
  };

  meta = with lib; {
    description = "Stupid simple graphical login manager";
    mainProgram = "dlm";
    homepage = "https://git.sr.ht/~kennylevinsen/dlm";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ luc65r ];
    platforms = platforms.linux;
  };
}
