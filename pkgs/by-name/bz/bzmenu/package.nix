{
  dbus,
  fetchFromGitHub,
  lib,
  pkg-config,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "bzmenu";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "e-tho";
    repo = "bzmenu";
    tag = "v${version}";
    hash = "sha256-42ZiENkqFXFhtqn26r9AIsG9sE+W0nGxm2zKdcbY5ss=";
  };

  cargoHash = "sha256-DvnWw4yH4ghFb368cms981pENez0zTgvpMghDTrah50=";

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
