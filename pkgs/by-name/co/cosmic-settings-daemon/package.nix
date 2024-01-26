{ lib
, fetchFromGitHub
, rustPlatform
, pkg-config
, udev
}:

rustPlatform.buildRustPackage rec {
  pname = "cosmic-settings-daemon";
  version = "unstable-2023-12-29";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = pname;
    rev = "f7183b68c6ca3f68054b5dd6457b1d5798a75a48";
    hash = "sha256-Wck0NY6CUjD16gxi74stayiahs4UiqS7iQCkbOXCgKE=";
  };

  cargoHash = "sha256-vCs20RdGhsI1+f78KEau7ohtoGTrGP9QH91wooQlgOE=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ udev ];

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-settings-daemon";
    description = "Settings Daemon for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ nyanbinary ];
    platforms = platforms.linux;
  };
}
