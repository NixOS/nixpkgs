{ lib
, stdenv
, fetchFromGitHub
, xorg
, imlib2
, picom
, feh
, acpi
, rofi
}:

stdenv.mkDerivation {
  name = "chadwm";
  version = "0-unstable-2024-02-14";
  src = fetchFromGitHub {
    owner = "siduck";
    repo = "chadwm";
    rev = "566de97abf2c06a18abec7c776a9d2d2edd12055";
    hash = "sha256-WX1vsbivOCEduAmTfXNTEKzNHQuh62LVkr5SmYrfte0=";
  };
  buildInputs = [
    imlib2
    picom
    feh
    acpi
    rofi
    xorg.libX11
    xorg.libXft
    xorg.libXinerama
    xorg.xsetroot
  ];
  makeFlags = [ "PREFIX=$(out)" ];
  preBuild = "cd chadwm";

  meta = with lib; {
    homepage = "https://github.com/siduck/chadwm";
    description = "Dwm fork that is amazingly efficient";
    license = licenses.mit;
    maintainers = with maintainers; [ binarycat ];
    platforms = platforms.linux;
  };
}
