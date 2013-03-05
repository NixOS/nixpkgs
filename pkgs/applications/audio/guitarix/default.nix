{ stdenv, fetchurl, python, gettext, intltool, pkgconfig, jackaudio, libsndfile
, glib, gtk, glibmm, gtkmm, fftw, librdf, ladspaH, boost }:

stdenv.mkDerivation rec {
  name = "guitarix-${version}";
  version = "0.25.2";

  src = fetchurl {
    url = "mirror://sourceforge/guitarix/guitarix2-${version}.tar.bz2";
    sha256 = "1wcg3yc2iy72hj6z9l88393f00by0iwhhn8xrc3q55p4rj0mnrga";
  };

  buildInputs =
    [ python gettext intltool pkgconfig jackaudio libsndfile glib gtk glibmm
      gtkmm fftw librdf ladspaH boost
    ];

  configurePhase = "python waf configure --prefix=$out";

  buildPhase = "python waf build";

  installPhase = "python waf install";

  meta = { 
    description = "A virtual guitar amplifier for Linux running with JACK";
    longDescription = ''
        guitarix is a virtual guitar amplifier for Linux running with
      JACK (Jack Audio Connection Kit). It is free as in speech and
      free as in beer. Its free sourcecode allows to build it for
      other UNIX-like systems also, namely for BSD and for MacOSX.

        It takes the signal from your guitar as any real amp would do:
      as a mono-signal from your sound card. Your tone is processed by
      a main amp and a rack-section. Both can be routed separately and
      deliver a processed stereo-signal via JACK. You may fill the
      rack with effects from more than 25 built-in modules spanning
      from a simple noise-gate to brain-slashing modulation-fx like
      flanger, phaser or auto-wah. Your signal is processed with
      minimum latency. On any properly set-up Linux-system you do not
      need to wait for more than 10 milli-seconds for your playing to
      be delivered, processed by guitarix.

        guitarix offers the range of sounds you would expect from a
      full-featured universal guitar-amp. You can get crisp
      clean-sounds, nice overdrive, fat distortion and a diversity of
      crazy sounds never heard before.
    '';
    homepage = http://guitarix.sourceforge.net/;
    license = stdenv.lib.licenses.gpl3Plus;
    maintainers = [ stdenv.lib.maintainers.astsmtl ];
    platforms = stdenv.lib.platforms.linux;
  };
}
