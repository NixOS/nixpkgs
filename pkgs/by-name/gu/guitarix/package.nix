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
  fftwFloat,
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

  enableFaust ? !stdenv.hostPlatform.isLinux, # Compile dsp files with Faust
  withBluez ? stdenv.hostPlatform.isLinux, # Enable Bluetooth support
  withZitaConvolver ? stdenv.hostPlatform.isLinux, # Use nixpkgs zita-convolver
  withZitaResampler ? stdenv.hostPlatform.isLinux, # Use nixpkgs zita-resampler
  optimizationSupport ? false, # Enable support for native CPU extensions
}:

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

  nativeBuildInputs =
    [
      gettext
      hicolor-icon-theme
      intltool
      pkg-config
      python3
      wafHook
      wrapGAppsHook3
    ]
    ++ lib.optionals enableFaust [
      faust
      # TODO: See if we can patch out the need for this
      which
    ];

  # TODO: identify sets of optional dependencies and add corresponding parameters
  buildInputs =
    [
      avahi
      boost
      curl
      eigen
      fftwFloat
      glib
      glib-networking
      glibmm
      gperf
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
    ]
    ++ lib.optional withBluez bluez
    ++ lib.optional withZitaConvolver zita-convolver
    ++ lib.optional withZitaResampler zita-resampler;

  # There are many bad shebangs which can fail builds.
  # See https://github.com/brummer10/guitarix/issues/97
  prePatch = ''
    patchShebangs --build tools/**
  '';

  postPatch = lib.optionalString enableFaust ''
    # Attempt to build with unsupported Faust versionso
    sed -ie "s/check_in_faust_version =.*/check_in_faust_version = '${faust.version}'/" wscript
  '';

  wafConfigureFlags =
    [
      "--no-font-cache-update"
      "--shared-lib"
      "--no-desktop-update"
      "--enable-nls"
      "--install-roboto-font"
    ]
    ++ lib.optional (!enableFaust) "--no-faust"
    ++ lib.optional (!withBluez) "--no-bluez"
    ++ lib.optional (!withZitaConvolver) "--includeconvolver"
    ++ lib.optional (!withZitaResampler) "--includeresampler"
    ++ lib.optional optimizationSupport "--optimization";

  env.NIX_CFLAGS_COMPILE = toString [ "-fpermissive" ];

  meta = {
    description = "Virtual guitar amplifier for Linux running with JACK";
    homepage = "https://github.com/brummer10/guitarix";
    license = lib.licenses.gpl3Plus;
    mainProgram = "guitarix";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      astsmtl
      lord-valen
    ];
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
  };
})
