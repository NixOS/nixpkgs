{ lib, stdenv, fetchurl, intltool, pkg-config, gtk2, gpgme, libgpg-error, libassuan }:

stdenv.mkDerivation rec {
  pname = "gpa";
  version = "0.10.0";

  src = fetchurl {
    url = "mirror://gnupg/gpa/gpa-${version}.tar.bz2";
    sha256 = "1cbpc45f8qbdkd62p12s3q2rdq6fa5xdzwmcwd3xrj55bzkspnwm";
  };

  nativeBuildInputs = [ intltool pkg-config ];
  buildInputs = [ gtk2 gpgme libgpg-error libassuan ];

  meta = with lib; {
    description = "Graphical user interface for the GnuPG";
    homepage = "https://www.gnupg.org/related_software/gpa/";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    mainProgram = "gpa";
  };
}
