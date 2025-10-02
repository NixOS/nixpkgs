{
  fetchFromGitHub,
  lib,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "iwmenu";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "e-tho";
    repo = "iwmenu";
    tag = "v${version}";
    hash = "sha256-Xge7olQxXrdLvtXrjOCEf4/maGmQa/OSQ38KqrOWvoY=";
  };

  cargoHash = "sha256-yi42BrdcAVEbkvPOyi4VxWO6F0x7vbjLZ/hLqWdeIn0=";

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
