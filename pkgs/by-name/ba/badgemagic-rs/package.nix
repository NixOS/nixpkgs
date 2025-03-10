{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, dbus
, udev
, stdenv
, darwin
,
}:

rustPlatform.buildRustPackage {
  pname = "badgemagic-rs";
  version = "0-unstable-2024-08-01";

  src = fetchFromGitHub {
    owner = "fossasia";
    repo = "badgemagic-rs";
    rev = "e7989e7";
    hash = "sha256-LNcYYMoavF4Ir+LBBx5iU5PviMIoT4szZT0A9PViGtk=";
  };

  cargoHash = "sha256-T11DNcxg3oPLYGT6s6XmO/py0J8ATMfYEphgVsx3RK8=";
  buildFeatures = [ "cli" ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    dbus
    udev
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.AppKit
    darwin.apple_sdk.frameworks.CoreGraphics
    darwin.apple_sdk.frameworks.Foundation
  ];

  meta = {
    description = "Badge Magic in Rust";
    homepage = "https://github.com/fossasia/badgemagic-rs";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ MoritzBoehme ];
    mainProgram = "badgemagic";
  };
}
