{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  qt5,
  cmake,
  ninja,
  avahi,
  # avahi-compat is used to avoid pulling the full avahi (and its dbus dependency)
  avahi-compat,
  boost,
  libopus,
  libsndfile,
  speexdsp,
  protobuf,
  libcap,
  python3,
  rnnoise,
  nixosTests,
  poco,
  flac,
  libogg,
  libvorbis,
  microsoft-gsl,
  nlohmann_json,
  xar,
  makeBinaryWrapper,
  # Which Mumble component to build. The `murmur` (server) and
  # `mumble-overlay` packages are derived from this one via `.override`.
  type ? "mumble",
  alsaSupport ? stdenv.hostPlatform.isLinux,
  alsa-lib,
  iceSupport ? false,
  zeroc-ice,
  jackSupport ? false,
  libjack2,
  pipewireSupport ? stdenv.hostPlatform.isLinux,
  pipewire,
  pulseSupport ? true,
  libpulseaudio,
  speechdSupport ? false,
  speechd-minimal,
}:

let
  isClient = type == "mumble";
  isServer = type == "murmur";
  isOverlay = type == "mumble-overlay";
in
stdenv.mkDerivation (finalAttrs: {
  pname = type;
  version = "1.5.901";

  src = fetchFromGitHub {
    owner = "mumble-voip";
    repo = "mumble";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UBJH7EwfWvInuSD6ZALOKeVnWdfh/rmq8GVLG5URjOQ=";
    fetchSubmodules = true;
  };

  patches = lib.optionals isClient [
    ./fix-plugin-copy.patch
  ];

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    python3
    qt5.wrapQtAppsHook
    qt5.qttools
    makeBinaryWrapper
  ];

  buildInputs = [
    boost
    poco
    protobuf
    microsoft-gsl
    nlohmann_json
  ]
  # The overlay is the only variant linked against the full avahi.
  ++ lib.optionals stdenv.hostPlatform.isLinux [ (if isOverlay then avahi else avahi-compat) ]
  ++ lib.optionals isClient (
    [
      flac
      libogg
      libopus
      libsndfile
      libvorbis
      speexdsp
      qt5.qtsvg
      rnnoise
    ]
    ++ lib.optional (!jackSupport && alsaSupport) alsa-lib
    ++ lib.optional jackSupport libjack2
    ++ lib.optional speechdSupport speechd-minimal
    ++ lib.optional pulseSupport libpulseaudio
    ++ lib.optional pipewireSupport pipewire
    ++ lib.optional stdenv.hostPlatform.isDarwin xar
  )
  ++ lib.optionals isServer ([ libcap ] ++ lib.optional iceSupport zeroc-ice);

  cmakeFlags = [
    (lib.cmakeBool "g15" false)
    (lib.cmakeFeature "CMAKE_CXX_STANDARD" "17") # protobuf >22 requires C++ 17
    (lib.cmakeFeature "BUILD_NUMBER" (lib.versions.patch finalAttrs.version))
    (lib.cmakeBool "CMAKE_UNITY_BUILD" true) # Upstream uses this in their build pipeline to speed up builds
    (lib.cmakeBool "bundled-gsl" false)
    (lib.cmakeBool "bundled-json" false)
    (lib.cmakeBool "bundled-speex" false)
    (lib.cmakeBool "bundle-qt-translations" false)
    (lib.cmakeBool "update" false)
    (lib.cmakeBool "use-timestamps" false)
    (lib.cmakeBool "warnings-as-errors" false) # protobuf 34.x `[[nodiscard]]` workaround https://github.com/mumble-voip/mumble/issues/7102 and `std::wstring_convert` deprecation workaround
  ]
  ++ lib.optionals isClient [
    (lib.cmakeBool "server" false)
    (lib.cmakeBool "overlay-xcompile" false)
    (lib.cmakeBool "oss" false)
    # building the overlay on darwin does not work in nipxkgs (yet)
    # also see the patch below to disable scripts the build option misses
    # see https://github.com/mumble-voip/mumble/issues/6816
    (lib.cmakeBool "overlay" (!stdenv.hostPlatform.isDarwin))
    (lib.cmakeBool "speechd" speechdSupport)
    (lib.cmakeBool "pulseaudio" pulseSupport)
    (lib.cmakeBool "pipewire" pipewireSupport)
    (lib.cmakeBool "jackaudio" jackSupport)
    (lib.cmakeBool "alsa" (!jackSupport && alsaSupport))
  ]
  ++ lib.optionals isServer (
    [
      (lib.cmakeBool "client" false)
      (lib.cmakeBool "ice" iceSupport)
    ]
    ++ lib.optionals iceSupport [
      (lib.cmakeFeature "Ice_HOME" "${lib.getDev zeroc-ice};${lib.getLib zeroc-ice}")
      (lib.cmakeFeature "Ice_SLICE_DIR" "${lib.getDev zeroc-ice}/share/ice/slice")
    ]
  )
  ++ lib.optionals isOverlay [
    (lib.cmakeBool "server" false)
    (lib.cmakeBool "client" false)
    (lib.cmakeBool "overlay" true)
  ];

  preConfigure = ''
    patchShebangs scripts
  '';

  env.NIX_CFLAGS_COMPILE = lib.optionalString (
    isClient && speechdSupport
  ) "-I${speechd-minimal}/include/speech-dispatcher";

  postInstall = lib.optionalString (isClient && stdenv.hostPlatform.isDarwin) ''
    # The build erraneously marks the *.dylib as executable
    # which causes the qt-hook to wrap it, which then prevents the app from loading it
    chmod -x $out/lib/mumble/plugins/*.dylib

    # Post-processing for the app bundle
    $NIX_BUILD_TOP/source/macx/scripts/osxdist.py \
      --source-dir=$NIX_BUILD_TOP/source/ \
      --binary-dir=$out \
      --only-appbundle \
      --no-overlay \
      --version "${finalAttrs.version}"

    mkdir -p $out/Applications $out/bin
    mv $out/Mumble.app $out/Applications/Mumble.app

    # ensure that the app can be started from the shell
    ln -s $out/Applications/Mumble.app/Contents/MacOS/mumble $out/bin/mumble
  '';

  postFixup = lib.optionalString (isClient && stdenv.hostPlatform.isLinux) ''
    wrapProgramBinary $out/bin/mumble \
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath (
          lib.optional pulseSupport libpulseaudio ++ lib.optional pipewireSupport pipewire
        )
      }"
  '';

  passthru.tests.connectivity = nixosTests.mumble;

  meta = {
    description = "Low-latency, high quality voice chat software";
    homepage = "https://mumble.info";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      felixsinger
      hax404
      lilacious
    ];
    platforms = lib.platforms.linux ++ lib.optionals isClient lib.platforms.darwin;
  }
  // lib.optionalAttrs (!isOverlay) {
    mainProgram = if isServer then "mumble-server" else "mumble";
  };
})
