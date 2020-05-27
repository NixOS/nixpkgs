{ stdenv, fetchurl, fetchpatch, faust, gettext, intltool, pkgconfig, python2
, avahi, bluez, boost, eigen, fftw, glib, glib-networking
, glibmm, gsettings-desktop-schemas, gtkmm2, libjack2
, ladspaH, libav, libsndfile, lilv, lrdf, lv2, serd, sord, sratom
, wrapGAppsHook, zita-convolver, zita-resampler, curl, wafHook
, optimizationSupport ? false # Enable support for native CPU extensions
}:

let
  inherit (stdenv.lib) optional;
in

stdenv.mkDerivation rec {
  pname = "guitarix";
  version = "0.39.0";

  src = fetchurl {
    url = "mirror://sourceforge/guitarix/guitarix2-${version}.tar.xz";
    sha256 = "1nn80m1qagfhvv69za60f0w6ck87vmk77qmqarj7fbr8avwg63s9";
  };

  patches = [
    (fetchpatch {
      url = "https://git.archlinux.org/svntogit/community.git/plain/trunk/guitarix-0.39.0-fix_faust_and_lv2_plugins.patch?id=8579b4dfe85e04303ad2d9771ed699f04ea7b7cf";
      stripLen = 1;
      sha256 = "0pgkhi4v4vrzjnig0ggmz207q4x5iyk2n6rjj8s5lv15fia7qzp4";
    })
  ];

  nativeBuildInputs = [ faust gettext intltool wrapGAppsHook pkgconfig python2 wafHook ];

  buildInputs = [
    avahi bluez boost eigen fftw glib glibmm glib-networking.out
    gsettings-desktop-schemas gtkmm2 libjack2 ladspaH libav
    libsndfile lilv lrdf lv2 serd sord sratom zita-convolver
    zita-resampler curl
  ];

  postPatch = ''
    # Fix build with lv2 1.18: https://github.com/brummer10/guitarix/commit/c0334c72
    find . -type f -exec fgrep -q LV2UI_Descriptor {} \; \
      -exec sed -i {} -e 's/const struct _\?LV2UI_Descriptor/const LV2UI_Descriptor/' \;
  '';

  wafConfigureFlags = [
    "--shared-lib"
    "--no-desktop-update"
    "--enable-nls"
    "--install-roboto-font"
    "--includeresampler"
    "--convolver-ffmpeg"
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
