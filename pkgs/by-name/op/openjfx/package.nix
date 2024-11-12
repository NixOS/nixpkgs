{
  featureVersion ? "17",

  lib,
  stdenv,
  pkgs,

  fetchpatch2,

  gradle,
  gradle_7,
  perl,
  pkg-config,
  cmake,
  gperf,
  python3,
  ruby,

  gtk2,
  gtk3,
  libXtst,
  libXxf86vm,
  glib,
  alsa-lib,
  ffmpeg,
  ffmpeg-headless,

  writeText,

  _experimental-update-script-combinators,
  nixpkgs-openjdk-updater,
  writeShellScript,
  path,

  withMedia ? true,
  withWebKit ? false,

  jdk17_headless,
  jdk21_headless,
  jdk23_headless,
  jdk-bootstrap ?
    {
      "17" = jdk17_headless;
      "21" = jdk21_headless;
      "23" = jdk23_headless;
    }
    .${featureVersion},
}:

let
  sourceFile = ./. + "/${featureVersion}/source.json";
  source = nixpkgs-openjdk-updater.openjdkSource {
    inherit sourceFile;
    featureVersionPrefix = featureVersion;
  };

  atLeast21 = lib.versionAtLeast featureVersion "21";
  atLeast23 = lib.versionAtLeast featureVersion "23";

  gradle_openjfx = if atLeast23 then gradle else gradle_7;
in

assert lib.assertMsg (lib.pathExists sourceFile)
  "OpenJFX ${featureVersion} is not a supported version";

stdenv.mkDerivation {
  pname = "openjfx-modular-sdk";
  version = lib.removePrefix "refs/tags/" source.src.rev;

  inherit (source) src;

  patches =
    if featureVersion == "23" then
      [
        # 8338701: Provide media support for libavcodec version 61
        # <https://github.com/openjdk/jfx23u/pull/18>
        (fetchpatch2 {
          url = "https://github.com/openjdk/jfx23u/commit/aba60fda1c82f00e8e685107592305c403a31287.patch?full_index=1";
          hash = "sha256-+aRhTwi4VQthAq1SH1jxPl0mTosNMKoTY52jm+jiKso=";
        })
      ]
    else if atLeast21 then
      [
        ./21/patches/backport-ffmpeg-7-support-jfx21.patch
      ]
    else
      [
        ./17/patches/backport-ffmpeg-6-support-jfx11.patch
        ./17/patches/backport-ffmpeg-7-support-jfx11.patch
      ];

  nativeBuildInputs = [
    gradle_openjfx
    perl
    pkg-config
    cmake
    gperf
    python3
    ruby
  ];

  buildInputs = [
    gtk2
    gtk3
    libXtst
    libXxf86vm
    glib
    alsa-lib
    (if atLeast21 then ffmpeg else ffmpeg-headless)
  ];

  mitmCache = gradle_openjfx.fetchDeps {
    attrPath = "openjfx${featureVersion}";
    pkg = pkgs."openjfx${featureVersion}".override { withWebKit = true; };
    data = ./. + "/${featureVersion}/deps.json";
  };

  gradleBuildTask = "sdk";

  stripDebugList = [ "." ];

  enableParallelBuilding = false;

  __darwinAllowLocalNetworking = true;

  env.config = writeText "gradle.properties" ''
    CONF = Release
    JDK_HOME = ${jdk-bootstrap.home}
    COMPILE_MEDIA = ${lib.boolToString withMedia}
    COMPILE_WEBKIT = ${lib.boolToString withWebKit}
  '';

  dontUseCmakeConfigure = true;

  postPatch =
    lib.optionalString (!atLeast23) ''
      # Add missing includes for gcc-13 for webkit build:
      sed -e '1i #include <cstdio>' \
        -i modules/javafx.web/src/main/native/Source/bmalloc/bmalloc/Heap.cpp \
           modules/javafx.web/src/main/native/Source/bmalloc/bmalloc/IsoSharedPageInlines.h

    ''
    + lib.optionalString (!atLeast21) ''
      substituteInPlace modules/javafx.web/src/main/native/Source/JavaScriptCore/offlineasm/parser.rb \
        --replace-fail "File.exists?" "File.exist?"

    ''
    + ''
      ln -s $config gradle.properties
    '';

  preBuild = ''
    export NUMBER_OF_PROCESSORS=$NIX_BUILD_CORES
    export NIX_CFLAGS_COMPILE="$(pkg-config --cflags glib-2.0) $NIX_CFLAGS_COMPILE"
  '';

  installPhase = ''
    cp -r build/modular-sdk $out
  '';

  postFixup = ''
    # Remove references to bootstrap.
    export openjdkOutPath='${jdk-bootstrap.outPath}'
    find "$out" -name \*.so | while read lib; do
      new_refs="$(patchelf --print-rpath "$lib" | perl -pe 's,:?\Q$ENV{openjdkOutPath}\E[^:]*,,')"
      patchelf --set-rpath "$new_refs" "$lib"
    done
  '';

  disallowedReferences = [
    jdk-bootstrap
    gradle_openjfx.jdk
  ];

  passthru.updateScript = _experimental-update-script-combinators.sequence [
    source.updateScript

    {
      command = [
        # We need to do this separate script rather than simply using
        # `finalAttrs.mitmCache.updateScript` because the Gradle update
        # script captures the source at the time of evaluation, making
        # it miss the update.
        (writeShellScript "update-openjfx-deps.sh" ''
          eval "$(
            nix-build "$1" \
            -A openjfx${featureVersion}.mitmCache.updateScript
          )"
        '')

        # This has to be a separate argument so that
        # `maintainers/scripts/update.py` can rewrite it to the
        # appropriate Git work tree.
        path
      ];

      supportedFeatures = [ "silent" ];
    }
  ];

  meta = {
    description = "Next-generation Java client toolkit";
    homepage = "https://openjdk.org/projects/openjfx/";
    license = lib.licenses.gpl2Classpath;
    maintainers = with lib.maintainers; [ abbradar ];
    platforms = lib.platforms.unix;
  };
}
