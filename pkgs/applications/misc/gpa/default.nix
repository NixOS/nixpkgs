{ stdenv, fetchurl, intltool, pkgconfig, gtk2, gpgme, libgpgerror, libassuan }:

stdenv.mkDerivation rec {
  name = "gpa-0.9.9";

  src = fetchurl {
    url = "mirror://gnupg/gpa/${name}.tar.bz2";
    sha256 = "0d235hcqai7m3qb7m9kvr2r4qg4714f87j9fdplwrlz1p4wdfa38";
  };

  buildInputs = [ intltool pkgconfig gtk2 gpgme libgpgerror libassuan ];

  meta = with stdenv.lib; {
    description = "Graphical user interface for the GnuPG";
    homepage = https://www.gnupg.org/related_software/gpa/;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
