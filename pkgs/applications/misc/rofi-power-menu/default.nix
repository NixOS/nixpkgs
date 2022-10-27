{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "rofi-power-menu";
  version = "3.0.2";

  src = fetchFromGitHub {
    owner = "jluttine";
    repo = "rofi-power-menu";
    rev = version;
    sha256 = "sha256-Bkc87BXSnAR517wCkyOAfoACYx/5xprDGJQhLWGUNns=";
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
  };
}
