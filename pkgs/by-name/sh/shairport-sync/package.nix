{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  openssl,
  avahi,
  alsa-lib,
  libplist,
  glib,
  libdaemon,
  libsodium,
  libgcrypt,
  ffmpeg-headless,
  libuuid,
  unixtools,
  popt,
  libconfig,
  libpulseaudio,
  libjack2,
  libsndfile,
  libao,
  libsoundio,
  mosquitto,
  nix-update-script,
  pipewire,
  soxr,
  sndio,
  enableAvahi ? true,
  enableAirplay2 ? false,
  enableStdout ? true,
  enableAlsa ? true,
  enableSndio ? true,
  enablePulse ? true,
  enablePipe ? true,
  enablePipewire ? true,
  enableAo ? true,
  enableJack ? true,
  enableSoundio ? true,
  enableMetadata ? true,
  enableMpris ? stdenv.hostPlatform.isLinux,
  enableMqttClient ? true,
  enableDbus ? stdenv.hostPlatform.isLinux,
  enableSoxr ? true,
  enableConvolution ? true,
  enableLibdaemon ? false,
  enableTinySVCmDNS ? true,

  # Enabling session bus support disables system bus support
  enableSessionBus ? true,
}:

let
  inherit (lib) optional optionals;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "shairport-sync";
  version = "5.6.2";

  src = fetchFromGitHub {
    repo = "shairport-sync";
    owner = "mikebrady";
    tag = finalAttrs.version;
    hash = "sha256-JiiZLgeYFoZ+Xq6tn1+KqW6Ewo+j+5JmxJ0Wm3dXqoE=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ]
  ++ optionals enableAirplay2 [
    libplist.bin
    unixtools.xxd
  ];

  buildInputs = [
    openssl
    popt
    libconfig
    ffmpeg-headless
  ]
  ++ optional enableAvahi avahi
  ++ optional enableLibdaemon libdaemon
  ++ optional enableAlsa alsa-lib
  ++ optional enableSndio sndio
  ++ optional enableMqttClient mosquitto
  ++ optional enablePulse libpulseaudio
  ++ optional enablePipewire pipewire
  ++ optional enableAo libao
  ++ optional enableJack libjack2
  ++ optional enableSoundio libsoundio
  ++ optional enableSoxr soxr
  ++ optional enableConvolution libsndfile
  ++ optionals enableAirplay2 [
    libplist
    libsodium
    libgcrypt
    libuuid
  ]
  ++ optional (enableDbus || enableMpris) glib;

  postPatch = lib.optionalString enableSessionBus ''
    substituteInPlace dbus/dbus-service.c --replace-fail 'G_BUS_TYPE_SYSTEM' 'G_BUS_TYPE_SESSION'
    substituteInPlace dbus/mpris-service.c --replace-fail 'G_BUS_TYPE_SYSTEM' 'G_BUS_TYPE_SESSION'
  '';

  enableParallelBuilding = true;

  preConfigure = lib.optionalString (enableDbus || enableMpris) ''
    export PATH=${glib.dev}/bin:$PATH
  '';

  configureFlags = [
    "--without-configfiles"
    "--sysconfdir=/etc"
    "--with-ssl=openssl"
  ]
  ++ optional enableAvahi "--with-avahi"
  ++ optional enablePulse "--with-pulseaudio"
  ++ optional enablePipewire "--with-pipewire"
  ++ optional enableAlsa "--with-alsa"
  ++ optional enableSndio "--with-sndio"
  ++ optional enableAo "--with-ao"
  ++ optional enableJack "--with-jack"
  ++ optional enableSoundio "--with-soundio"
  ++ optional enableStdout "--with-stdout"
  ++ optional enablePipe "--with-pipe"
  ++ optional enableSoxr "--with-soxr"
  ++ optional enableConvolution "--with-convolution"
  ++ optional enableDbus "--with-dbus-interface"
  ++ optional enableMetadata "--with-metadata"
  ++ optional enableMpris "--with-mpris-interface"
  ++ optional enableMqttClient "--with-mqtt-client"
  ++ optional enableTinySVCmDNS "--with-tinysvcmdns"
  ++ optional enableLibdaemon "--with-libdaemon"
  ++ optional enableAirplay2 "--with-airplay-2";

  strictDeps = true;
  __structuredAttrs = true;

  passthru.updateScript = nix-update-script {
    # ignore -dev tagged releases
    extraArgs = [ "--version-regex=^([0-9\\.]+)$" ];
  };

  meta = {
    homepage = "https://github.com/mikebrady/shairport-sync";
    description = "Airtunes server and emulator with multi-room capabilities";
    changelog = "https://github.com/mikebrady/shairport-sync/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "shairport-sync";
    maintainers = with lib.maintainers; [
      jordanisaacs
    ];
    platforms = lib.platforms.unix;
  };
})
