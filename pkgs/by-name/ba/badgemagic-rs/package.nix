{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, dbus
, udev
}:

rustPlatform.buildRustPackage {
  pname = "badgemagic-rs";
  version = "0-unstable-2025-07-15";

  src = fetchFromGitHub {
    owner = "fossasia";
    repo = "badgemagic-rs";
    rev = "5d745ab";
    hash = "sha256-IyPUPNbXkLNz/cuzVuzrD2iCE1ddeO3xkAOKhbrNU+k=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-oaJo3crPA06n8vYJFlwgZjJ8zNGjIfQ6lTltlkb9Bbk=";
  buildFeatures = [ "cli" ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    dbus
    udev
  ];

  meta = {
    description = "Badge Magic in Rust";
    homepage = "https://github.com/fossasia/badgemagic-rs";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ MoritzBoehme ];
    mainProgram = "badgemagic";
  };
}
