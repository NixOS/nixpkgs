{ stdenv, fetchurl, intltool, pkgconfig, gtk2, gpgme, libgpgerror, libassuan }:

stdenv.mkDerivation rec {
  name = "gpa-0.9.10";

  src = fetchurl {
    url = "mirror://gnupg/gpa/${name}.tar.bz2";
    sha256 = "09xphbi2456qynwqq5n0yh0zdmdi2ggrj3wk4hsyh5lrzlvcrff3";
  };

  nativeBuildInputs = [ intltool pkgconfig ];
  buildInputs = [ gtk2 gpgme libgpgerror libassuan ];

  meta = with stdenv.lib; {
    description = "Graphical user interface for the GnuPG";
    homepage = https://www.gnupg.org/related_software/gpa/;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
