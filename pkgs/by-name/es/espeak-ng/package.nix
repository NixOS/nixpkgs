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
  runCommandLocal,

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
  buildPackages,
}:

let
  version = "1.52.0.1-unstable-2025-09-09";

  src = fetchFromGitHub {
    owner = "espeak-ng";
    repo = "espeak-ng";
    rev = "0d451f8c1c6ae837418b823bd9c4cbc574ea9ff5";
    hash = "sha256-wpPi+YjSLhsEWfE3KEbL4A7o48qtz9fLRZ/u4xGOM2g=";
  };

  ucd-tools = stdenv.mkDerivation {
    pname = "ucd-tools";
    inherit version src;

    sourceRoot = "${src.name}/src/ucd-tools";

    # fix compatibility with CMake (https://cmake.org/cmake/help/v4.0/policy/CMP0000.html)
    postPatch = ''
      echo 'cmake_minimum_required(VERSION 4.0)' >> CMakeLists.txt
    '';

    nativeBuildInputs = [ cmake ];

    installPhase = ''
      runHook preInstall
      mkdir $out
      cp -v libucd.a $out/
      runHook postInstall
    '';
  };
in

stdenv.mkDerivation (finalAttrs: {
  pname = "espeak-ng";
  inherit version src;

  __structuredAttrs = true;
  strictDeps = true;

  patches = [
    # https://github.com/espeak-ng/espeak-ng/pull/2274
    (fetchpatch {
      name = "libsonic.patch";
      url = "https://github.com/espeak-ng/espeak-ng/commit/83e646e711af608fafa8c01dd812cd29e073f644.patch";
      hash = "sha256-UHuURyqRy/JVYYJH5EI5J2cpBfCNeTE24sMmheb+D2Q=";
    })
    # Remove after next release.
    (fetchpatch {
      name = "cmake-default-ESPEAK_COMPAT-to-ON.patch";
      url = "https://github.com/espeak-ng/espeak-ng/commit/3dcbe7ea3ea85a9212968d0f05172dde4259e770.patch";
      hash = "sha256-U694hGe+cwy7qLe/6XmNHYIhccJGsbM0CzPZT5pIpUI=";
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
  ]
  # Provide a native espeak-ng when cross compiling so intonations can be built
  ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    buildPackages.espeak-ng
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
  ]
  # Point CMake to the native build’s binary dir when cross compiling
  ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "-DNativeBuild_DIR=${buildPackages.espeak-ng}/bin/"
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    wrapProgram $out/bin/espeak-ng \
      --set ALSA_PLUGIN_DIR ${alsa-plugins}/lib/alsa-lib
  '';

  passthru = {
    inherit mbrolaSupport ucd-tools;

    tests = {
      voices = runCommandLocal "espeak-ng-voices-test" { } ''
        set -u
        fail=0

        voices=$(
          ${lib.getExe finalAttrs.finalPackage} --voices \
            | tail -n +2 \
            | awk '{print $5}'
        )

        mkdir -p "$out"
        for voice in $voices; do
          # Replace / with _ for safe filenames in $out
          safe_name=$(echo "$voice" | tr '/' '_')
          wav="$out/$safe_name.wav"
          err="$out/$safe_name.err"

          if ! ${lib.getExe finalAttrs.finalPackage} -v "$voice" "This is a test" -w "$wav" 2>"$err"; then
            echo "FAIL (exit code): $voice" >&2
            cat "$err" >&2
            fail=1
            continue
          fi

          size=$(stat -c%s "$wav" 2>/dev/null || echo 0)
          if [ "$size" -le 44 ]; then
            echo "FAIL (empty output): $voice" >&2
            fail=1
          else
            echo "OK: $voice" >&2
          fi
        done

        exit "$fail"
      '';
    }
    // lib.optionalAttrs mbrolaSupport {
      mbrolaVoices = runCommandLocal "espeak-ng-mbrola-voices-test" { } ''
        set -u
        fail=0

        voices=$(
          ${lib.getExe finalAttrs.finalPackage} --voices=mb \
            | tail -n +2 \
            | awk '{print $5}'
        )

        mkdir -p "$out"
        for voice in $voices; do
          safe_name=$(echo "$voice" | tr '/' '_')
          wav="$out/$safe_name.wav"
          err="$out/$safe_name.err"

          if ! ${lib.getExe finalAttrs.finalPackage} -v "$voice" "This is a test" -w "$wav" 2>"$err"; then
            echo "FAIL (exit code): $voice" >&2
            cat "$err" >&2
            fail=1
            continue
          fi

          size=$(stat -c%s "$wav" 2>/dev/null || echo 0)
          if [ "$size" -le 44 ]; then
            echo "FAIL (empty output): $voice" >&2
            fail=1
          else
            echo "OK: $voice" >&2
          fi
        done

        exit "$fail"
      '';
    };
  };

  meta = {
    description = "Speech synthesizer that supports more than hundred languages and accents";
    homepage = "https://github.com/espeak-ng/espeak-ng";
    changelog = "https://github.com/espeak-ng/espeak-ng/blob/${src.rev}/ChangeLog.md";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ aske ];
    platforms = lib.platforms.all;
    mainProgram = "espeak-ng";
  };
})
