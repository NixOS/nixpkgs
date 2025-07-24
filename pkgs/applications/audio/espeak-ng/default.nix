{
  stdenv,
  lib,
  fetchFromGitHub,
  replaceVars,

  # build system
  autoconf,
  automake,
  cmake,
  libtool,
  makeWrapper,
  ninja,
  pkg-config,
  ronn,
  which,

  # dependencies
  alsa-plugins,
  asyncSupport ? true,
  klattSupport ? true,
  mbrola,
  mbrolaSupport ? true,
  pcaudiolib,
  pcaudiolibSupport ? true,
  sonic,
  sonicSupport ? true,
  speechPlayerSupport ? true,
}:

stdenv.mkDerivation rec {
  pname = "espeak-ng";
  version = "1.52.0";

  src = fetchFromGitHub {
    owner = "espeak-ng";
    repo = "espeak-ng";
    tag = version;
    hash = "sha256-mmh5QPSVD5YQ0j16R+bEL5vcyWLtTNOJ/irBNzWY3ro=";
  };

  patches = [
    # https://github.com/espeak-ng/espeak-ng/pull/2274
    ./libsonic.patch
  ]
  ++ lib.optionals mbrolaSupport [
    # Hardcode correct mbrola paths.
    (replaceVars ./mbrola.patch {
      inherit mbrola;
    })
  ];

  nativeBuildInputs = [
    autoconf
    automake
    cmake
    libtool
    ninja
    pkg-config
    ronn
    makeWrapper
    which
  ];

  buildInputs =
    lib.optional mbrolaSupport mbrola
    ++ lib.optional pcaudiolibSupport pcaudiolib
    ++ lib.optional sonicSupport sonic;

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" true)
    (lib.cmakeBool "USE_ASYNC" asyncSupport)
    (lib.cmakeBool "USE_KLATT" klattSupport)
    (lib.cmakeBool "USE_LIBPCAUDIO" pcaudiolibSupport)
    (lib.cmakeBool "USE_LIBSONIC" sonicSupport)
    (lib.cmakeBool "USE_MBROLA" mbrolaSupport)
    (lib.cmakeBool "USE_SPEECHPLAYER" speechPlayerSupport)
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    wrapProgram $out/bin/espeak-ng \
      --set ALSA_PLUGIN_DIR ${alsa-plugins}/lib/alsa-lib
  '';

  passthru = {
    inherit mbrolaSupport;
  };

  meta = {
    description = "Speech synthesizer that supports more than hundred languages and accents";
    homepage = "https://github.com/espeak-ng/espeak-ng";
    changelog = "https://github.com/espeak-ng/espeak-ng/blob/${src.tag}/ChangeLog.md";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ aske ];
    platforms = lib.platforms.all;
    mainProgram = "espeak-ng";
  };
}
