{ stdenv, fetchurl, fetchpatch, cairo, expat, fftwSinglePrec, fluidsynth, glib
, gtk2, libjack2, ladspaH , libglade, lv2, pkgconfig }:

stdenv.mkDerivation rec {
  name = "calf-${version}";
  version = "0.90.0";

  src = fetchurl {
    url = "https://calf-studio-gear.org/files/${name}.tar.gz";
    sha256 = "0dijv2j7vlp76l10s4v8gbav26ibaqk8s24ci74vrc398xy00cib";
  };

  patches = [
    # Fix memory leak in limiter
    # https://github.com/flathub/com.github.wwmm.pulseeffects/issues/12
    (fetchpatch {
      url = https://github.com/calf-studio-gear/calf/commit/7afdefc0d0489a6227fd10f15843d81dc82afd62.patch;
      sha256 = "056662iw6hp4ykwk4jyrzg5yarcn17ni97yc060y5kcnzy29ddg6";
    })
  ];

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
