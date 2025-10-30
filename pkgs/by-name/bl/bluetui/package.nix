{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  dbus,
}:

rustPlatform.buildRustPackage rec {
  pname = "bluetui";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "pythops";
    repo = "bluetui";
    rev = "v${version}";
    hash = "sha256-wc17dgwlUILeSxTokJpZRx8fLZRrc50WjseVjEtwsLE=";
  };

  cargoHash = "sha256-REGWMDtAK/PjSFt3tnYmcVpmfmyGbwVLUa8uHdFEfaQ=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    dbus
  ];

  meta = {
    description = "TUI for managing bluetooth on Linux";
    homepage = "https://github.com/pythops/bluetui";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ donovanglover ];
    mainProgram = "bluetui";
    platforms = lib.platforms.linux;
  };
}
