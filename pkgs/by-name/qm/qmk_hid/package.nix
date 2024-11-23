{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  systemd,
}:

rustPlatform.buildRustPackage rec {
  pname = "qmk_hid";
  version = "0.1.12";

  src = fetchFromGitHub {
    owner = "FrameworkComputer";
    repo = "qmk_hid";
    rev = "v${version}";
    hash = "sha256-wJi7FQrvMbdTwvbbjBnzmxupMbEuM8TeZ0JIK5ulQKI=";
  };

  cargoHash = "sha256-X8pBv4dFiiLDKDjyW3XpVOdzq5c5/4GcRL6jnJ8Rf1A=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    systemd
  ];

  checkFlags = [
    # test doesn't compile
    "--skip=src/lib.rs"
  ];

  meta = with lib; {
    description = "Commandline tool for interactng with QMK devices over HID";
    homepage = "https://github.com/FrameworkComputer/qmk_hid";
    license = with licenses; [ bsd3 ];
    maintainers = [ ];
    mainProgram = "qmk_hid";
  };
}
