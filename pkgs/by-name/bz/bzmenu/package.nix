{
  dbus,
  fetchFromGitHub,
  lib,
  pkg-config,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "bzmenu";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "e-tho";
    repo = "bzmenu";
    tag = "v${version}";
    hash = "sha256-5Xb/7DhwZ3hLO1rAceMaR3ifgI36Sn+W+S7PN8EOdOQ=";
  };

  cargoHash = "sha256-zTwgWk5ix1TGTi8rZjznJqdHbgnRHjA42Ly7PQQiMZw=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    dbus
  ];

  meta = {
    homepage = "https://github.com/e-tho/bzmenu";
    description = "Launcher-driven Bluetooth manager for Linux";
    longDescription = ''
      Use `bzmenu --launcher <launcher command>`
      Supported launchers are: `dmenu`, `fuzzel`, `rofi`, `walker` and `custom` with `stdin`
      for details refer to https://github.com/e-tho/bzmenu/blob/main/README.md#usage
    '';
    mainProgram = "bzmenu";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ vuimuich ];
  };
}
