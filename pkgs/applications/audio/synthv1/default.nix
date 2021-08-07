{ mkDerivation, lib, fetchurl, pkg-config, qtbase, qttools, libjack2, alsa-lib, liblo, lv2 }:

mkDerivation rec {
  pname = "synthv1";
  version = "0.9.15";

  src = fetchurl {
    url = "mirror://sourceforge/synthv1/${pname}-${version}.tar.gz";
    sha256 = "047y2l7ipzv00ly54f074v6p043xjml7vz0svc7z81bhx74vs0ix";
  };

  buildInputs = [ qtbase qttools libjack2 alsa-lib liblo lv2 ];

  nativeBuildInputs = [ pkg-config ];

  meta = with lib; {
    description = "An old-school 4-oscillator subtractive polyphonic synthesizer with stereo fx";
    homepage = "https://synthv1.sourceforge.io/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}
