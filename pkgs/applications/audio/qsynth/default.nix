{ stdenv, fetchurl, alsaLib, fluidsynth, libjack2, qtbase, qttools, qtx11extras, cmake, pkgconfig }:

stdenv.mkDerivation  rec {
  name = "qsynth-${version}";
  version = "0.5.0";

  src = fetchurl {
    url = "mirror://sourceforge/qsynth/${name}.tar.gz";
    sha256 = "1sr6vrz8z9r99j9xcix86lgcqldragb2ajmq1bnhr58d99sda584";
  };

  # cmake is looking for qsynth.desktop.in and fails if it doesn't find it
  # seems like a bug and can presumable go in the next version after 0.5.0
  postPatch = ''
    mv src/qsynth.desktop src/qsynth.desktop.in
  '';

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [ alsaLib fluidsynth libjack2 qtbase qttools qtx11extras ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Fluidsynth GUI";
    homepage = https://sourceforge.net/projects/qsynth;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ goibhniu ];
    platforms = platforms.linux;
  };
}
