{ stdenv, fetchurl, asciidoc, asciidoctor, autoconf, automake, cmake,
  docbook_xsl, fftw, fftwFloat, gfortran, libtool, libusb1, qtbase,
  qtmultimedia, qtserialport, qttools, texinfo, wrapQtAppsHook }:

stdenv.mkDerivation rec {
  pname = "wsjtx";
  version = "2.1.2";

  # This is a "superbuild" tarball containing both wsjtx and a hamlib fork
  src = fetchurl {
    url = "http://physics.princeton.edu/pulsar/k1jt/wsjtx-${version}.tgz";
    sha256 = "0aj3wg5xjjqwjvw6lra171ag5wq86w0hf1ra4k8mnaf0mc1qgbyl";
  };

  # Hamlib builds with autotools, wsjtx builds with cmake
  # Omitting pkgconfig because it causes issues locating the built hamlib
  nativeBuildInputs = [
    asciidoc asciidoctor autoconf automake cmake docbook_xsl gfortran libtool
    qttools texinfo wrapQtAppsHook
  ];
  buildInputs = [ fftw fftwFloat libusb1 qtbase qtmultimedia qtserialport ];

  # Remove Git dependency from superbuild since sources are included
  patches = [ ./super.patch ];

  # Superbuild has its own patch step after it extracts the inner archives
  postPatch = "cp ${./wsjtx.patch} wsjtx.patch";

  meta = with stdenv.lib; {
    description = "Weak-signal digital communication modes for amateur radio";
    longDescription = ''
      WSJT-X implements communication protocols or "modes" called FT4, FT8, JT4,
      JT9, JT65, QRA64, ISCAT, MSK144, and WSPR, as well as one called Echo for
      detecting and measuring your own radio signals reflected from the Moon.
      These modes were all designed for making reliable, confirmed ham radio
      contacts under extreme weak-signal conditions.
    '';
    homepage = "https://physics.princeton.edu/pulsar/k1jt/wsjtx.html";
    # Older licenses are for the statically-linked hamlib
    license = with licenses; [ gpl3Plus gpl2Plus lgpl21Plus ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ lasandell ];
  };
}
