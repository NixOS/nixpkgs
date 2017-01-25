{ stdenv, fetchurl, pkgconfig, autoconf, automake, gettext
, fluxbox, bc, gtkmm2, glibmm, libglademm, libsigcxx }:

stdenv.mkDerivation rec{

  name = "fme-${version}";
  version = "1.1.3";
  
  src = fetchurl {
    url = "https://github.com/rdehouss/fme/archive/v${version}.tar.gz";
    sha256 = "d1c81a6a38c0faad02943ad65d6d0314bd205c6de841669a2efe43e4c503e63d";
  };

  buildInputs = [ pkgconfig autoconf automake gettext fluxbox bc gtkmm2 glibmm libglademm libsigcxx ];

  preConfigure = ''
    ./autogen.sh
  '';

  meta = with stdenv.lib; {
    description = "Editor for Fluxbox menus";
    longDescription = ''
      Fluxbox Menu Editor is a menu editor for the Window Manager Fluxbox written in C++
      with the libraries Gtkmm, Glibmm, libglademm and gettext for internationalization.
      Its user-friendly interface will help you to edit, delete, move (Drag and Drop)
      a row, a submenu, etc very easily.
    '';
    homepage = https://github.com/rdehouss/fme/;
    license = licenses.gpl2;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.linux;
  };
}
