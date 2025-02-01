{
  lib,
  fetchFromGitHub,
  stdenv,
  rustPlatform,
  pkg-config,
  libinput,
  udev,
}:

rustPlatform.buildRustPackage rec {
  pname = "cosmic-settings-daemon";
  version = "1.0.0-alpha.5.1";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-settings-daemon";
    rev = "epoch-${version}";
    hash = "sha256-MlBnwbszwJCa/FQNihSKsy7Bllw807C8qQL9ziYS3fE=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-ianyD+ws/t2Qg+UG3eGE1WP2dHS2iWdCTolk/ZH/Ddg=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libinput
    udev
  ];

  makeFlags = [
    "prefix=$(out)"
    "CARGO_TARGET_DIR=target/${stdenv.hostPlatform.rust.cargoShortTarget}"
  ];

  dontCargoInstall = true;

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-settings-daemon";
    description = "Settings Daemon for the COSMIC Desktop Environment";
    mainProgram = "cosmic-settings-daemon";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ nyabinary ];
    platforms = platforms.linux;
  };
}
