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
  ffmpeg,
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
  pipewire,
  soxr,
  alac,
  sndio,
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
  enableAlac ? true,
  enableConvolution ? true,
  enableLibdaemon ? false,
}:

let
  inherit (lib) optional optionals;
in

stdenv.mkDerivation rec {
  pname = "shairport-sync";
  version = "4.3.7";

  src = fetchFromGitHub {
    repo = "shairport-sync";
    owner = "mikebrady";
    tag = version;
    hash = "sha256-bfOgUeUCxQeCmKKBlvIXptM5lJxgZiH4lOhLJSNih8g=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    # For glib we want the `dev` output for the same library we are
    # also linking against, since pkgsHostTarget.glib.dev exposes
    # some extra tools that are built for build->host execution.
    # To achieve this, we coerce the output to a string to prevent
    # mkDerivation's splicing logic from kicking in.
    "${glib.dev}"
  ]
  ++ optional enableAirplay2 [
    unixtools.xxd
  ];

  buildInputs = [
    openssl
    avahi
    popt
    libconfig
  ]
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
  ++ optional enableAlac alac
  ++ optional enableConvolution libsndfile
  ++ optionals enableAirplay2 [
    libplist
    libsodium
    libgcrypt
    libuuid
    ffmpeg
  ]
  ++ optional stdenv.hostPlatform.isLinux glib;

  postPatch = ''
    sed -i -e 's/G_BUS_TYPE_SYSTEM/G_BUS_TYPE_SESSION/g' dbus-service.c
    sed -i -e 's/G_BUS_TYPE_SYSTEM/G_BUS_TYPE_SESSION/g' mpris-service.c
  '';

  enableParallelBuilding = true;

  configureFlags = [
    "--without-configfiles"
    "--sysconfdir=/etc"
    "--with-ssl=openssl"
    "--with-stdout"
    "--with-avahi"
  ]
  ++ optional enablePulse "--with-pa"
  ++ optional enablePipewire "--with-pw"
  ++ optional enableAlsa "--with-alsa"
  ++ optional enableSndio "--with-sndio"
  ++ optional enableAo "--with-ao"
  ++ optional enableJack "--with-jack"
  ++ optional enableSoundio "--with-soundio"
  ++ optional enableStdout "--with-stdout"
  ++ optional enablePipe "--with-pipe"
  ++ optional enableSoxr "--with-soxr"
  ++ optional enableAlac "--with-apple-alac"
  ++ optional enableConvolution "--with-convolution"
  ++ optional enableDbus "--with-dbus-interface"
  ++ optional enableMetadata "--with-metadata"
  ++ optional enableMpris "--with-mpris-interface"
  ++ optional enableMqttClient "--with-mqtt-client"
  ++ optional enableLibdaemon "--with-libdaemon"
  ++ optional enableAirplay2 "--with-airplay-2";

  strictDeps = true;

  meta = {
    homepage = "https://github.com/mikebrady/shairport-sync";
    description = "Airtunes server and emulator with multi-room capabilities";
    license = lib.licenses.mit;
    mainProgram = "shairport-sync";
    maintainers = with lib.maintainers; [
      lnl7
      jordanisaacs
    ];
    platforms = lib.platforms.unix;
  };
}
