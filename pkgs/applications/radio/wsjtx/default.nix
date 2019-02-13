{ stdenv, fetchurl, asciidoc, asciidoctor, autoconf, automake, cmake,
  docbook_xsl, fftw, fftwFloat, gfortran, libtool, qtbase,
  qtmultimedia, qtserialport, texinfo, libusb1 }:

stdenv.mkDerivation rec {
  name = "wsjtx-${version}";
  version = "2.0.0";

  # This is a "superbuild" tarball containing both wsjtx and a hamlib fork
  src = fetchurl {
    url = "http://physics.princeton.edu/pulsar/k1jt/wsjtx-${version}.tgz";
    sha256 = "66434f69f256742da1fe057ec51e4464cab2614f0bfb1a310c04a385b77bd014";
  };

  # Hamlib builds with autotools, wsjtx builds with cmake
  # Omitting pkgconfig because it causes issues locating the built hamlib
  nativeBuildInputs = [
    asciidoc asciidoctor autoconf automake cmake docbook_xsl gfortran libtool
    texinfo
  ];
  buildInputs = [ fftw fftwFloat libusb1 qtbase qtmultimedia qtserialport ];

  # Remove Git dependency from superbuild since sources are included
  patches = [ ./super.patch ];

  # Superbuild has its own patch step after it extracts the inner archives
  postPatch = "cp ${./wsjtx.patch} wsjtx.patch";

  meta = with stdenv.lib; {
    description = "Weak-signal digital communication modes for amateur radio";
    longDescription = ''
      WSJT-X implements communication protocols or "modes" called FT8, JT4, JT9,
      JT65, QRA64, ISCAT, MSK144, and WSPR, as well as one called Echo for
      detecting and measuring your own radio signals reflected from the Moon.
      These modes were all designed for making reliable, confirmed ham radio
      contacts under extreme weak-signal conditions.
    '';
    homepage = http://physics.princeton.edu/pulsar/k1jt/wsjtx.html;
    # Older licenses are for the statically-linked hamlib
    license = with licenses; [ gpl3Plus gpl2Plus lgpl21Plus ];
    platforms = platforms.linux;
    maintainers = [ maintainers.lasandell ];
  };
}
