{ stdenv
, fetchurl
, avahi
, bluez
, boost
, curl
, eigen
, fftw
, gettext
, glib
, glib-networking
, glibmm
, gnome3
, gsettings-desktop-schemas
, gtk3
, gtkmm3
, hicolor-icon-theme
, intltool
, ladspaH
, libav
, libjack2
, libsndfile
, lilv
, lrdf
, lv2
, pkgconfig
, python2
, sassc
, serd
, sord
, sratom
, wafHook
, wrapGAppsHook
, zita-convolver
, zita-resampler
, optimizationSupport ? false # Enable support for native CPU extensions
}:

let
  inherit (stdenv.lib) optional;
in

stdenv.mkDerivation rec {
  pname = "guitarix";
  version = "0.41.0";

  src = fetchurl {
    url = "mirror://sourceforge/guitarix/guitarix2-${version}.tar.xz";
    sha256 = "0qsfbyrrpb3bbdyq68k28mjql7kglxh8nqcw9jvja28x6x9ik5a0";
  };

  nativeBuildInputs = [
    gettext
    hicolor-icon-theme
    intltool
    pkgconfig
    python2
    wafHook
    wrapGAppsHook
  ];

  buildInputs = [
    avahi
    bluez
    boost
    curl
    eigen
    fftw
    glib
    glib-networking.out
    glibmm
    gnome3.adwaita-icon-theme
    gsettings-desktop-schemas
    gtk3
    gtkmm3
    ladspaH
    libav
    libjack2
    libsndfile
    lilv
    lrdf
    lv2
    sassc
    serd
    sord
    sratom
    zita-convolver
    zita-resampler
  ];

  # this doesnt build, probably because we have the wrong faust version:
  #       "--faust"
  # aproved versions are 2.20.2 and 2.15.11
  wafConfigureFlags = [
    "--no-faust"
    "--no-font-cache-update"
    "--shared-lib"
    "--no-desktop-update"
    "--enable-nls"
    "--install-roboto-font"
  ] ++ optional optimizationSupport "--optimization";

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
    homepage = "http://guitarix.sourceforge.net/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ astsmtl goibhniu ];
    platforms = platforms.linux;
  };
}
