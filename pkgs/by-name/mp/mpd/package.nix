{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  glib,
  systemd,
  fmt,
  buildPackages,
  # Inputs
  curl,
  libcdio,
  libcdio-paranoia,
  libmms,
  libnfs,
  liburing,
  samba,
  # Archive support
  bzip2,
  zziplib,
  # Codecs
  audiofile,
  faad2,
  ffmpeg,
  flac,
  fluidsynth,
  game-music-emu,
  libmad,
  libmikmod,
  mpg123,
  libopus,
  libvorbis,
  lame,
  # Filters
  libsamplerate,
  soxr,
  # Outputs
  alsa-lib,
  libao,
  libjack2,
  libpulseaudio,
  libshout,
  pipewire,
  # Misc
  icu,
  sqlite,
  avahi,
  dbus,
  pcre2,
  libgcrypt,
  expat,
  nlohmann_json,
  zlib,
  libupnp,
  # Client support
  libmpdclient,
  # Tag support
  libid3tag,
  nixosTests,
  # For documentation
  doxygen,
  python3Packages, # for sphinx-build
  # For tests
  gtest,
  zip,
  # Features list
  features ? null,
}:

let
  concatAttrVals = nameList: set: lib.concatMap (x: set.${x} or [ ]) nameList;

  featureDependencies = {
    # Storage plugins
    udisks = [ dbus ];
    webdav = [
      curl
      expat
    ];
    # Input plugins
    cdio_paranoia = [
      libcdio
      libcdio-paranoia
    ];
    curl = [ curl ];
    io_uring = [ liburing ];
    mms = [ libmms ];
    nfs = [ libnfs ];
    smbclient = [ samba ];
    # Archive support
    bzip2 = [ bzip2 ];
    zzip = [ zziplib ];
    # Decoder plugins
    audiofile = [ audiofile ];
    faad = [ faad2 ];
    ffmpeg = [ ffmpeg ];
    flac = [ flac ];
    fluidsynth = [ fluidsynth ];
    gme = [ game-music-emu ];
    mad = [ libmad ];
    mikmod = [ libmikmod ];
    mpg123 = [
      libid3tag
      mpg123
    ];
    opus = [ libopus ];
    vorbis = [ libvorbis ];
    # Encoder plugins
    vorbisenc = [ libvorbis ];
    lame = [ lame ];
    # Filter plugins
    libsamplerate = [ libsamplerate ];
    soxr = [ soxr ];
    # Output plugins
    alsa = [ alsa-lib ];
    ao = [ libao ];
    jack = [ libjack2 ];
    pipewire = [ pipewire ];
    pulse = [ libpulseaudio ];
    shout = [ libshout ];
    # Commercial services
    qobuz = [
      curl
      libgcrypt
      nlohmann_json
    ];
    # Client support
    libmpdclient = [ libmpdclient ];
    # Tag support
    id3tag = [
      libid3tag
      zlib
    ];
    # Misc
    dbus = [ dbus ];
    expat = [ expat ];
    icu = [ icu ];
    pcre = [ pcre2 ];
    sqlite = [ sqlite ];
    syslog = [ ];
    systemd = [ systemd ];
    zeroconf = [
      avahi
      dbus
    ];
  };

  nativeFeatureDependencies = {
    documentation = [
      doxygen
      python3Packages.sphinx
    ];
  };

  # Disable platform specific features if needed
  # using libmad to decode mp3 files on darwin is causing a segfault -- there
  # is probably a solution, but I'm disabling it for now
  platformMask =
    lib.optionals stdenv.hostPlatform.isDarwin [
      "mad"
      "pulse"
      "jack"
      "smbclient"
    ]
    ++ lib.optionals (!stdenv.hostPlatform.isLinux) [
      "alsa"
      "pipewire"
      "io_uring"
      "systemd"
      "syslog"
    ];

  knownFeatures =
    builtins.attrNames featureDependencies ++ builtins.attrNames nativeFeatureDependencies;
  platformFeatures = lib.subtractLists platformMask knownFeatures;

  features_ =
    if (features == null) then
      platformFeatures
    else
      let
        unknown = lib.subtractLists knownFeatures features;
      in
      if (unknown != [ ]) then
        throw "Unknown feature(s): ${lib.concatStringsSep " " unknown}"
      else
        let
          unsupported = lib.subtractLists platformFeatures features;
        in
        if (unsupported != [ ]) then
          throw "Feature(s) ${lib.concatStringsSep " " unsupported} are not supported on ${stdenv.hostPlatform.system}"
        else
          features;

in
stdenv.mkDerivation (finalAttrs: {
  pname = "mpd";
  version = "0.24.5";

  src = fetchFromGitHub {
    owner = "MusicPlayerDaemon";
    repo = "MPD";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-MgepOQeOl+n65+7b8zXe2u0fCHFAviSqL1aNu2iSXiM=";
  };

  buildInputs = [
    glib
    fmt
    # According to the configurePhase of meson, gtest is considered a
    # runtime dependency. Quoting:
    #
    #    Run-time dependency GTest found: YES 1.10.0
    gtest
    libupnp
  ]
  ++ concatAttrVals features_ featureDependencies;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ]
  ++ concatAttrVals features_ nativeFeatureDependencies;

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  postPatch =
    lib.optionalString
      (stdenv.hostPlatform.isDarwin && lib.versionOlder stdenv.hostPlatform.darwinSdkVersion "12.0")
      ''
        substituteInPlace src/output/plugins/OSXOutputPlugin.cxx \
          --replace kAudioObjectPropertyElement{Main,Master} \
          --replace kAudioHardwareServiceDeviceProperty_Virtual{Main,Master}Volume
      '';

  # Otherwise, the meson log says:
  #
  #    Program zip found: NO
  nativeCheckInputs = [ zip ];

  doCheck = true;

  mesonAutoFeatures = "disabled";

  outputs = [
    "out"
    "doc"
  ]
  ++ lib.optional (builtins.elem "documentation" features_) "man";

  CXXFLAGS = lib.optionals stdenv.hostPlatform.isDarwin [
    "-D__ASSERT_MACROS_DEFINE_VERSIONS_WITHOUT_UNDERSCORES=0"
  ];

  mesonFlags = [
    "-Dtest=true"
    "-Dmanpages=true"
    "-Dhtml_manual=true"
  ]
  ++ map (x: "-D${x}=enabled") features_
  ++ map (x: "-D${x}=disabled") (lib.subtractLists features_ knownFeatures)
  ++ lib.optional (builtins.elem "zeroconf" features_) (
    "-Dzeroconf=" + (if stdenv.hostPlatform.isDarwin then "bonjour" else "avahi")
  )
  ++ lib.optional (builtins.elem "systemd" features_) "-Dsystemd_system_unit_dir=etc/systemd/system"
  ++ lib.optional (builtins.elem "qobuz" features_) "-Dnlohmann_json=enabled";

  passthru.tests.nixos = nixosTests.mpd;

  meta = {
    description = "Flexible, powerful daemon for playing music";
    homepage = "https://www.musicpd.org/";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [
      tobim
    ];
    platforms = lib.platforms.unix;
    mainProgram = "mpd";

    longDescription = ''
      Music Player Daemon (MPD) is a flexible, powerful daemon for playing
      music. Through plugins and libraries it can play a variety of sound
      files while being controlled by its network protocol.
    '';
  };
})
