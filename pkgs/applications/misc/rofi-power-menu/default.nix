{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "rofi-power-menu";
<<<<<<< HEAD
  version = "3.1.0";
=======
  version = "3.0.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "jluttine";
    repo = "rofi-power-menu";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-VPCfmCTr6ADNT7MW4jiqLI/lvTjlAu1QrCAugiD0toU=";
=======
    sha256 = "sha256-Bkc87BXSnAR517wCkyOAfoACYx/5xprDGJQhLWGUNns=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  installPhase = ''
    mkdir -p $out/bin
    cp rofi-power-menu $out/bin/rofi-power-menu
    cp dmenu-power-menu $out/bin/dmenu-power-menu
  '';

  meta = with lib; {
    description = "Shows a Power/Lock menu with Rofi";
    homepage = "https://github.com/jluttine/rofi-power-menu";
    maintainers = with maintainers; [ ikervagyok ];
    platforms = platforms.linux;
<<<<<<< HEAD
    mainProgram = "rofi-power-menu";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
