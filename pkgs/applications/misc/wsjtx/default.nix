{ stdenv, fetchurl, asciidoc, asciidoctor, autoconf, automake, cmake,
  docbook_xsl, fftw, fftwFloat, gfortran, libtool, libpulseaudio, qtbase,
  qtmultimedia, qtserialport, texinfo, libusb1 }:

stdenv.mkDerivation rec {
  name = "wsjtx-${version}";
  version = "1.8.0";

  # This is a composite source tarball containing both wsjtx and a hamlib fork
  src = fetchurl {
    url = "http://physics.princeton.edu/pulsar/K1JT/wsjtx-${version}.tgz";
    sha256 = "21603ad4d5f43cd9c79a6e8cf468bde88c554654012b2c6c1ef9144cfbf668ce";
  };

  # Hamlib builds with autotools, wsjtx builds with cmake
  # Omitting pkgconfig because it causes issues locating the built hamlib
  nativeBuildInputs = [
    asciidoc asciidoctor autoconf automake cmake docbook_xsl gfortran libtool
    texinfo
  ];
  buildInputs = [ fftw fftwFloat libusb1 qtbase qtmultimedia qtserialport ];

  # Composite build has its own patch step after it extracts the inner archives
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
