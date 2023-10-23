{
  lib
, fetchFromGitHub
, rustPlatform
, pkg-config
, libusb1
, udev
, nix-update-script
}:

rustPlatform.buildRustPackage rec {
  pname = "cyme";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "tuna-f1sh";
    repo = "cyme";
    rev = "v${version}";
    hash = "sha256-UXh97pHJ9wa/xSslHLB7WVDwLKJYvLPgmPX8RvKrsTI=";
  };

  cargoHash = "sha256-hSd53K50Y4K/fYGfsT2fHUaipVSpeYN6/EOFlv4ocuE=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libusb1 udev ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://github.com/tuna-f1sh/cyme";
    description = "A modern cross-platform lsusb";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ h7x4 ];
    platforms = platforms.unix;
    mainProgram = "cyme";
  };
}
