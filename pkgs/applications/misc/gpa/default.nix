{ stdenv, fetchurl, intltool, pkgconfig, gtk, gpgme, libgpgerror, libassuan }:

stdenv.mkDerivation rec {
  
  name = "gpa-0.9.7";

  src = fetchurl {
    url = "mirror://gnupg/gpa/${name}.tar.bz2";
    sha256 = "1r8pnvfw66b2m9lhajlarbxx9172c1gzripdij01bawgbrhwp33y";
  };

  buildInputs = [ intltool pkgconfig gtk gpgme libgpgerror libassuan ];

  meta = with stdenv.lib; {
    description = "Graphical user interface for the GnuPG";
    homepage = https://www.gnupg.org/related_software/gpa/;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
