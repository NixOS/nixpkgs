{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  hidapi,
  udev,
}:

rustPlatform.buildRustPackage {
  pname = "leddy";
  version = "0.1.0-unstable-2024-10-15";
  src = fetchFromGitHub {
    owner = "XanClic";
    repo = "leddy";
    rev = "fd259425980df17bd761006a1ccef93e23bfdad6";
    hash = "sha256-7t+E47odtayw26AnhtkxIWr0TxDwruEjP3Af3ajmVAA=";
  };

  cargoHash = "sha256-ezl9/vKDPJNYH1U4H/7OtE0g3iWIS+tDapJDhaKT+l0=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    hidapi
    udev
  ];
  doCheck = false; # no tests

  meta = {
    description = "LED controller for the Fnatic miniStreak and Fnatic Streak keyboards";
    homepage = "https://github.com/XanClic/leddy";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.jmir ];
    mainProgram = "leddy";
  };
}
