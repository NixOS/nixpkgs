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

  cargoHash = "sha256-aKKayT+3PuxhqXCCIQwHZkkoGBj8NSVWf1d0i4GZSAU=";

  meta = with lib; {
    description = "Stupid simple graphical login manager";
    mainProgram = "dlm";
    homepage = "https://git.sr.ht/~kennylevinsen/dlm";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ luc65r ];
    platforms = platforms.linux;
  };
}
