{
  dbus,
  fetchFromGitHub,
  lib,
  iwd,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "iwmenu";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "e-tho";
    repo = "iwmenu";
    tag = "v${version}";
    hash = "sha256-F1w2Lp0/iXUHh0PXAZ/wD78C2uVtAcWlEKqBI5I/hnE=";
  };

  cargoHash = "sha256-NjA8n11pOytXsotEQurYxDHPhwXG5vpdlyscmVUIzfA=";

  buildInputs = [
    dbus
    iwd
  ];

  meta = {
    homepage = "https://github.com/e-tho/iwmenu";
    description = "Launcher-driven Wi-Fi manager for Linux";
    longDescription = ''
      Use `iwmenu --launcher <launcher command>`
      Supported launchers are: `dmenu`, `fuzzel`, `rofi`, `walker` and `custom` with `stdin`
      for details refer to https://github.com/e-tho/iwmenu/blob/main/README.md#usage
    '';
    mainProgram = "iwmenu";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ vuimuich ];
  };
}
