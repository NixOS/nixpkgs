{ stdenv, fetchurl, alsaLib, autoconf, automake, dssi, gtk, jack2,
ladspaH, ladspaPlugins, liblo, pkgconfig }:

stdenv.mkDerivation  rec {
  name = "xsynth-dssi-${version}";
  version = "0.9.4";

  src = fetchurl {
    url = "mirror://sourceforge/dssi/${name}.tar.gz";
    sha256 = "00nwv2pqjbmxqdc6xdm0cljq6z05lv4y6bibmhz1kih9lm0lklnk";
  };

  buildInputs = [ alsaLib autoconf automake dssi gtk jack2 ladspaH
    ladspaPlugins liblo pkgconfig ];

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/lib
    cp src/Xsynth_gtk $out/bin
    cp src/.libs/* $out/lib
  '';

  meta = with stdenv.lib; {
    description = "classic-analog (VCOs-VCF-VCA) style software synthesizer";
    longDescription = ''
      Xsynth-DSSI is a classic-analog (VCOs-VCF-VCA) style software
      synthesizer which operates as a plugin for the DSSI Soft Synth
      Interface.  DSSI is a plugin API for software instruments (soft
      synths) with user interfaces, permitting them to be hosted
      in-process by audio applications.
    '';
    homepage = "http://dssi.sourceforge.net/download.html#Xsynth-DSSI";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}
