{ stdenv, fetchurl, intltool, pkgconfig, gtk2, gpgme, libgpgerror, libassuan }:

stdenv.mkDerivation rec {
  name = "gpa-0.10.0";

  src = fetchurl {
    url = "mirror://gnupg/gpa/${name}.tar.bz2";
    sha256 = "1cbpc45f8qbdkd62p12s3q2rdq6fa5xdzwmcwd3xrj55bzkspnwm";
  };

  nativeBuildInputs = [ intltool pkgconfig ];
  buildInputs = [ gtk2 gpgme libgpgerror libassuan ];

  meta = with stdenv.lib; {
    description = "Graphical user interface for the GnuPG";
    homepage = https://www.gnupg.org/related_software/gpa/;
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
  };
}
