{ lib, stdenv
, cmake
, gettext
, src
}:

stdenv.mkDerivation {
  inherit src;

  pname = "kicad-i18n";
  version = builtins.substring 0 10 src.rev;

  nativeBuildInputs = [ cmake gettext ];
  meta = with lib; {
    license = licenses.gpl2; # https://github.com/KiCad/kicad-i18n/issues/3
    platforms = platforms.all;
  };
}
