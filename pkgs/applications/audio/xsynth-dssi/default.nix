{ lib, stdenv, fetchurl, alsa-lib, autoconf, automake, dssi, gtk2, libjack2,
ladspaH, ladspaPlugins, liblo, pkg-config }:

stdenv.mkDerivation  rec {
  pname = "xsynth-dssi";
  version = "0.9.4";

  src = fetchurl {
    url = "mirror://sourceforge/dssi/${pname}-${version}.tar.gz";
    sha256 = "00nwv2pqjbmxqdc6xdm0cljq6z05lv4y6bibmhz1kih9lm0lklnk";
  };

  nativeBuildInputs = [ autoconf automake pkg-config ];
  buildInputs = [ alsa-lib dssi gtk2 libjack2 ladspaH
    ladspaPlugins liblo ];

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/lib
    cp src/Xsynth_gtk $out/bin
    cp src/.libs/* $out/lib
  '';

  meta = with lib; {
    description = "Classic-analog (VCOs-VCF-VCA) style software synthesizer";
    mainProgram = "Xsynth_gtk";
    longDescription = ''
      Xsynth-DSSI is a classic-analog (VCOs-VCF-VCA) style software
      synthesizer which operates as a plugin for the DSSI Soft Synth
      Interface.  DSSI is a plugin API for software instruments (soft
      synths) with user interfaces, permitting them to be hosted
      in-process by audio applications.
    '';
    homepage = "https://dssi.sourceforge.net/download.html#Xsynth-DSSI";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}
