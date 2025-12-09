{
  lib,
  stdenv,
  fetchFromGitHub,
  avahi,
  bluez,
  boost,
  curl,
  eigen,
  faust,
  fftwSinglePrec,
  gettext,
  glib,
  glib-networking,
  glibmm,
  gperf,
  adwaita-icon-theme,
  gsettings-desktop-schemas,
  gtk3,
  gtkmm3,
  hicolor-icon-theme,
  intltool,
  ladspaH,
  libjack2,
  liblo,
  libsndfile,
  lilv,
  lrdf,
  lv2,
  pkg-config,
  python3,
  sassc,
  serd,
  sord,
  sratom,
  wafHook,
  which,
  wrapGAppsHook3,
  zita-convolver,
  zita-resampler,
  optimizationSupport ? false, # Enable support for native CPU extensions
}:

let
  inherit (lib) optional;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "guitarix";
  version = "0.47.0";

  src = fetchFromGitHub {
    owner = "brummer10";
    repo = "guitarix";
    tag = "V${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-YQqcpdehfC9UE1OowC1/YUw2eWgbLWMbAJ3V5tVmtiU=";
  };

  sourceRoot = "${finalAttrs.src.name}/trunk";

  nativeBuildInputs = [
    gettext
    gperf
    hicolor-icon-theme
    intltool
    pkg-config
    python3
    wafHook
    which
    wrapGAppsHook3
  ];

  # TODO: Identify optional dependencies and add corresponding parameters.
  buildInputs = [
    avahi
    bluez
    boost
    curl
    eigen
    faust
    fftwSinglePrec
    glib
    glib-networking.out
    glibmm
    adwaita-icon-theme
    gsettings-desktop-schemas
    gtk3
    gtkmm3
    ladspaH
    libjack2
    liblo
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

  # There are many bad shebangs which can fail builds.
  # See `https://github.com/brummer10/guitarix/issues/246`.
  prePatch = ''
    patchShebangs --build tools/**
  '';

  wafConfigureFlags = [
    "--no-font-cache-update"
    "--shared-lib"
    "--no-desktop-update"
    "--enable-nls"
    "--install-roboto-font"
    "--faust"
  ]
  ++ optional optimizationSupport "--optimization";

  meta = {
    description = "Virtual guitar amplifier for Linux running with JACK";
    mainProgram = "guitarix";
    longDescription = ''
      Guitarix takes the signal from your guitar as any real amp would do: as a
      mono-signal from your sound card. Your tone is processed by a main amp and
      a rack-section. Both can be routed separately and deliver a processed
      stereo-signal via JACK. You may fill the rack with effects from more than
      25 built-in modules spanning from a simple noise-gate to brain-slashing
      modulation-fx like flanger, phaser or auto-wah. Your signal is processed
      with minimum latency. On a properly set-up Linux-system you do not need to
      wait for more than 10 milliseconds for your playing to be delivered,
      processed by guitarix.

      Guitarix offers the range of sounds you would expect from a full-featured
      universal guitar-amp. You can get crisp clean-sounds, nice overdrive, fat
      distortion and a diversity of crazy sounds never heard before.
    '';
    homepage = "https://github.com/brummer10/guitarix";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      lord-valen
    ];
    platforms = lib.platforms.linux;
  };
})
