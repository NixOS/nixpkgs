{ lib
, stdenv
, fetchFromGitHub
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
, adwaita-icon-theme
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
, wrapGAppsHook3
, zita-convolver
, zita-resampler
, optimizationSupport ? false # Enable support for native CPU extensions
}:

let
  inherit (lib) optional;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "guitarix";
  version = "0.46.0";

  src = fetchFromGitHub {
    owner = "brummer10";
    repo = "guitarix";
    rev = "V${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-AftC6fQEDzG/3C/83YbK/++bRgP7vPD0E2X6KEWpowc=";
  };

  sourceRoot = "${finalAttrs.src.name}/trunk";

  nativeBuildInputs = [
    gettext
    hicolor-icon-theme
    intltool
    pkg-config
    python3
    wafHook
    wrapGAppsHook3
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
    adwaita-icon-theme
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
    description = "Virtual guitar amplifier for Linux running with JACK";
    mainProgram = "guitarix";
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
    homepage = "https://github.com/brummer10/guitarix";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ astsmtl lord-valen ];
    platforms = platforms.linux;
  };
})
