{
  fetchFromGitHub,
  lib,
  pipewire,
  pkg-config,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "pwmenu";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "e-tho";
    repo = "pwmenu";
    tag = "v${version}";
    hash = "sha256-Q02kOMC6oQ3fNyDWW9ztLgMs3wR4cA53/wmkbecTr/o=";
  };

  cargoHash = "sha256-jX4D4Xv2WYTcWnYO2cNsu7L9ppIw//Tkxl+Y7tflk+A=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    pipewire
  ];

  meta = {
    homepage = "https://github.com/e-tho/pwmenu";
    description = "Launcher-driven audio manager for Linux";
    longDescription = ''
      Use `pwmenu --launcher <launcher command>`
      Supported launchers are: `dmenu`, `fuzzel`, `rofi`, `walker` and `custom` with `stdin`
      for details refer to https://github.com/e-tho/pwmenu/blob/main/README.md#usage
    '';
    mainProgram = "pwmenu";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ vuimuich ];
  };
}
