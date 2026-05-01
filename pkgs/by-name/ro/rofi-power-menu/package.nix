{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rofi-power-menu";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "jluttine";
    repo = "rofi-power-menu";
    rev = finalAttrs.version;
    sha256 = "sha256-VPCfmCTr6ADNT7MW4jiqLI/lvTjlAu1QrCAugiD0toU=";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp rofi-power-menu $out/bin/rofi-power-menu
    cp dmenu-power-menu $out/bin/dmenu-power-menu
  '';

  meta = {
    description = "Shows a Power/Lock menu with Rofi";
    homepage = "https://github.com/jluttine/rofi-power-menu";
    maintainers = with lib.maintainers; [ ikervagyok ];
    platforms = lib.platforms.linux;
    mainProgram = "rofi-power-menu";
  };
})
