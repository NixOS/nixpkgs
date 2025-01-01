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
  version = "1.0.0-alpha.4";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-settings-daemon";
    rev = "epoch-${version}";
    hash = "sha256-wwrbZJ/FA6qjeo9M/gIlzVyygiLT3R5OTLhTwr/QSSw=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-zAVBkH6ADs8uXqHD1gHQJl1e5l+g6NdnhEJa5fSvHDE=";

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
