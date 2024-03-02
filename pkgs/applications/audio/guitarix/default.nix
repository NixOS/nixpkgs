{ lib
, stdenv
, fetchurl
, fetchpatch
, avahi
, bluez
, boost
, curl
, eigen
, faust
, fftw
, gettext
, glib
, glib-networking
, glibmm
, gnome
, gsettings-desktop-schemas
, gtk3
, gtkmm3
, hicolor-icon-theme
, intltool
, ladspaH
, libjack2
, libsndfile
, lilv
, lrdf
, lv2
, pkg-config
, python3
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
  inherit (lib) optional;
in

stdenv.mkDerivation rec {
  pname = "guitarix";
  version = "0.44.1";

  src = fetchurl {
    url = "mirror://sourceforge/guitarix/guitarix2-${version}.tar.xz";
    sha256 = "d+g9dU9RrDjFQj847rVd5bPiYSjmC1EbAtLe/PNubBg=";
  };

  patches = [
    (fetchpatch {
      name = "gcc13-fixes.patch";
      url = "https://github.com/brummer10/guitarix/commit/b52736180b6966f24398f8a5ad179a58173473ec.patch";
      hash = "sha256-+jilgLujy/B6ijUb8NHzt3+4IKCt17X8LmuMLdmsvGw=";
      relative = "trunk";
    })
  ];

  # doesnt apply cleanly, so doing with substituteInPlace
  # https://github.com/brummer10/guitarix/commit/39d7c21c4173eb0f121b1bbff439d9cf43331a00.patch
  postPatch = ''
    substituteInPlace wscript --replace "open(src_fname, 'rU')" "open(src_fname, 'r')"
  '';

  nativeBuildInputs = [
    gettext
    hicolor-icon-theme
    intltool
    pkg-config
    python3
    wafHook
    wrapGAppsHook
  ];

  buildInputs = [
    avahi
    bluez
    boost
    curl
    eigen
    faust
    fftw
    glib
    glib-networking.out
    glibmm
    gnome.adwaita-icon-theme
    gsettings-desktop-schemas
    gtk3
    gtkmm3
    ladspaH
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

  wafConfigureFlags = [
    "--no-font-cache-update"
    "--shared-lib"
    "--no-desktop-update"
    "--enable-nls"
    "--install-roboto-font"
  ] ++ optional optimizationSupport "--optimization";

  env.NIX_CFLAGS_COMPILE = toString [ "-fpermissive" ];

  meta = with lib; {
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
