{
  fetchFromGitHub,
  lib,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "iwmenu";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "e-tho";
    repo = "iwmenu";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2DprhM1gaKWqj3eORLqTuy5Qq0htI+kQhKR3rM0DL/Y=";
  };

  cargoHash = "sha256-PGB/gTDRSnnJMj78KtdFk9w4BWFjz2ehv0ShcRL//KA=";

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
})
