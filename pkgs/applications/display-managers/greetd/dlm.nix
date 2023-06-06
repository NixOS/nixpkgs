{ lib
, rustPlatform
, fetchFromSourcehut
}:

rustPlatform.buildRustPackage rec {
  pname = "dlm";
  version = "2020-01-07";

  src = fetchFromSourcehut {
    owner = "~kennylevinsen";
    repo = pname;
    rev = "6b0e11c4f453b1a4d7a32019227539a980b7ce66";
    sha256 = "1r3w7my0g3v2ya317qnvjx8wnagjahpj7yx72a65hf2pjbf5x42p";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "greet_proto-0.2.0" = "sha256-91TsxEvMfVGpPIS9slHP1YHM2DKxpO4v/CP5iGphIyY=";
    };
  };

  meta = with lib; {
    description = "A stupid simple graphical login manager";
    homepage = "https://git.sr.ht/~kennylevinsen/dlm";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ luc65r ];
    platforms = platforms.linux;
  };
}
