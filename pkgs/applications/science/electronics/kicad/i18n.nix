{ stdenv
, cmake
, gettext
, src
, version
}:

stdenv.mkDerivation {
  inherit src version;

  pname = "kicad-i18n";

  nativeBuildInputs = [ cmake gettext ];
  meta = with stdenv.lib; {
    license = licenses.gpl2; # https://github.com/KiCad/kicad-i18n/issues/3
    platforms = platforms.all;
  };
}
