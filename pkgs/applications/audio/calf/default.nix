{ lib, stdenv, fetchurl, cairo, expat, fftwSinglePrec, fluidsynth, glib
, gtk2, libjack2, ladspaH , libglade, lv2, pkg-config }:

stdenv.mkDerivation rec {
  pname = "calf";
  version = "0.90.3";

  src = fetchurl {
    url = "https://calf-studio-gear.org/files/${pname}-${version}.tar.gz";
    sha256 = "17x4hylgq4dn9qycsdacfxy64f5cv57n2qgkvsdp524gnqzw4az3";
  };

  enableParallelBuilding = true;

  buildInputs = [
    cairo expat fftwSinglePrec fluidsynth glib gtk2 libjack2 ladspaH
    libglade lv2 pkg-config
  ];

  meta = with lib; {
    homepage = "http://calf-studio-gear.org";
    description = "A set of high quality open source audio plugins for musicians";
    license = licenses.lgpl2;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
