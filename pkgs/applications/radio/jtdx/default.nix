{ lib, stdenv, fetchFromGitHub, asciidoc, asciidoctor, autoconf, automake, cmake,
  docbook_xsl, fftw, fftwFloat, gfortran, libtool, libusb1, qtbase,
  qtmultimedia, qtserialport, qttools, boost, texinfo, wrapQtAppsHook, jtdxhamlib, libsForQt5 }:

stdenv.mkDerivation rec {
  pname = "jtdx";
  version = "2.2.159";

  src = fetchFromGitHub {
    owner = "jtdx-project";
    repo = "jtdx";
    rev = "159";
    sha256 = "sha256-5KlFBlzG3hKFFGO37c+VN+FvZKSnTQXvSorB+Grns8w=";
  };

  nativeBuildInputs = [
    asciidoc asciidoctor autoconf automake cmake docbook_xsl gfortran libtool
    qttools texinfo wrapQtAppsHook libsForQt5.qtwebsockets
  ];
  buildInputs = [ fftw fftwFloat libusb1 qtbase qtmultimedia qtserialport boost jtdxhamlib ];

  meta = with lib; {
    description = "JTDX is a fork of WSJT-X, an amateur radio communication program using very weak signals";
    longDescription = ''
      JTDX means "JT modes for DXing", it is being developed with main focus on
      the sensitivity and decoding efficiency, both, in overcrowded and half
      empty HF band conditions.

      It is open source software distributed under the GPL v3 license, and is
      based on the WSJT-X r6462 source code.

      Optimal candidate selection logic, four/five pass decoding and decoders
      based on the matched filters making JTDX performance quite different from
      WSJT-X software for operation on the HF bands.

      Almost all work goes around JT65 mode, decoding efficieny of JT9 mode is
      the same as in WSJT-X and might be addressed in the future JTDX versions.
    '';
    homepage = "https://sourceforge.net/projects/jtdx/files/";
    license = with licenses; [ gpl3Plus ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ CesarGallego nilp0inter ];
  };
}
