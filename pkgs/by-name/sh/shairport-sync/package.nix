{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
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
  version = "5.5.2";

  src = fetchFromGitHub {
    repo = "shairport-sync";
    owner = "mikebrady";
    tag = finalAttrs.version;
    hash = "sha256-mSPuvUzfvm/kZS0LDJhve7SAB35jSH7hhOcOxPXuLww=";
  };

  patches = [
    (fetchpatch2 {
      name = "decode-classic-l16-uncompressed-pcm-in-ffmpeg-builds.patch";
      url = "https://github.com/mikebrady/shairport-sync/commit/be30b6b2cc08fb679bbe9a1bff3f76068736952d.patch";
      hash = "sha256-1mLRp4tH7DZQ3HFDXI7Rm99g2jJp+aIkY1tsov9Yi38=";
    })
  ];

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
    ffmpeg
  ]
  ++ optional (enableDbus || enableMpris) glib;

  postPatch = lib.optionalString enableSessionBus ''
    sed -i -e 's/G_BUS_TYPE_SYSTEM/G_BUS_TYPE_SESSION/g' dbus-service.c
    sed -i -e 's/G_BUS_TYPE_SYSTEM/G_BUS_TYPE_SESSION/g' mpris-service.c
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
    license = lib.licenses.mit;
    mainProgram = "shairport-sync";
    maintainers = with lib.maintainers; [
      jordanisaacs
    ];
    platforms = lib.platforms.unix;
  };
})
