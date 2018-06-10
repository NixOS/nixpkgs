{ stdenv, fetchurl, cairo, expat, fftwSinglePrec, fluidsynth, glib
, gtk2, libjack2, ladspaH , libglade, lv2, pkgconfig }:

stdenv.mkDerivation rec {
  name = "calf-${version}";
  version = "0.90.0";

  src = fetchurl {
    url = "http://calf-studio-gear.org/files/${name}.tar.gz";
    sha256 = "0dijv2j7vlp76l10s4v8gbav26ibaqk8s24ci74vrc398xy00cib";
  };

  buildInputs = [
    cairo expat fftwSinglePrec fluidsynth glib gtk2 libjack2 ladspaH
    libglade lv2 pkgconfig
  ];

  meta = with stdenv.lib; {
    homepage = http://calf-studio-gear.org;
    description = "A set of high quality open source audio plugins for musicians";
    license = licenses.lgpl2;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
