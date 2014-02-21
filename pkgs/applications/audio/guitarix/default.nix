{ stdenv, fetchurl, avahi, boost, fftw, gettext, glib, glibmm, gtk
, gtkmm, intltool, jackaudio, ladspaH, librdf, libsndfile, lv2 
, pkgconfig, python }:

stdenv.mkDerivation rec {
  name = "guitarix-${version}";
  version = "0.28.3";

  src = fetchurl {
    url = "mirror://sourceforge/guitarix/guitarix2-${version}.tar.bz2";
    sha256 = "0ks5avylyicqfj9l1wf4gj62i8m6is2jmp0h11h5l2wbg3xiwxjd";
  };

  buildInputs = [
    avahi boost fftw gettext glib glibmm gtk gtkmm intltool jackaudio
    ladspaH librdf libsndfile lv2 pkgconfig python
  ];

  configurePhase = "python waf configure --prefix=$out";

  buildPhase = "python waf build";

  installPhase = "python waf install";

  meta = with stdenv.lib; { 
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
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ astsmtl goibhniu ];
    platforms = platforms.linux;
  };
}
