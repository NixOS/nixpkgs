{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
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
  ucdSupport ? false,
}:

let
  version = "1.52.0";

  src = fetchFromGitHub {
    owner = "espeak-ng";
    repo = "espeak-ng";
    tag = version;
    hash = "sha256-mmh5QPSVD5YQ0j16R+bEL5vcyWLtTNOJ/irBNzWY3ro=";
  };

  ucd-tools = stdenv.mkDerivation {
    pname = "ucd-tools";
    inherit version src;

    sourceRoot = "${src.name}/src/ucd-tools";

    nativeBuildInputs = [ cmake ];

    installPhase = ''
      runHook preInstall
      mkdir $out
      cp -v libucd.a $out/
      runHook postInstall
    '';
  };
in

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
    (fetchpatch {
      name = "espeak-ng-text-to-phonemes-with-terminator.patch";
      url = "https://github.com/espeak-ng/espeak-ng/commit/2108b1e8ae02f49cc909894a1024efdfde6682fd.patch";
      hash = "sha256-XjEc1r7F88xZOfeUey0R6Xv6vu4Wy8GtWxXFG2NTf9g=";
    })
  ]
  ++ lib.optionals mbrolaSupport [
    # Hardcode correct mbrola paths.
    (replaceVars ./mbrola.patch {
      inherit mbrola;
    })
  ];

  postPatch = lib.optionalString ucdSupport ''
    ln -s ${ucd-tools}/libucd.a src/ucd-tools/libucd.a
  '';

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
    inherit mbrolaSupport ucd-tools;
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
