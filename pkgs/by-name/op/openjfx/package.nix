{
  featureVersion ? "21",

  lib,
  stdenv,
  pkgs,

  gradle_8,
  gradle_9,
  perl,
  pkg-config,
  cmake,
  gperf,
  python3,
  ruby,

  gtk3,
  libxtst,
  libxxf86vm,
  glib,
  alsa-lib,
  ffmpeg_7,
  ffmpeg_7-headless,

  fetchpatch2,
  writeText,

  _experimental-update-script-combinators,
  nixpkgs-openjdk-updater,
  writeShellScript,
  path,

  withMedia ? true,
  withWebKit ? false,

  jdk17_headless,
  jdk21_headless,
  jdk25_headless,
  jdk27_headless,
  jdk-bootstrap ?
    {
      "17" = jdk17_headless;
      "21" = jdk21_headless;
      "25" = jdk25_headless;
      "27" = jdk27_headless;
    }
    .${featureVersion},
}:

let
  gradle = if lib.versionAtLeast featureVersion "27" then gradle_9 else gradle_8;

  sourceFile = ./. + "/${featureVersion}/source.json";
  source = nixpkgs-openjdk-updater.openjdkSource {
    inherit sourceFile;
    featureVersionPrefix = featureVersion;
  };

  atLeast21 = lib.versionAtLeast featureVersion "21";
  atLeast23 = lib.versionAtLeast featureVersion "23";
in

assert lib.assertMsg (lib.pathExists sourceFile)
  "OpenJFX ${featureVersion} is not a supported version";

stdenv.mkDerivation {
  pname = "openjfx-modular-sdk";
  version = lib.removePrefix "refs/tags/" source.src.rev;

  inherit (source) src;

  __structuredAttrs = lib.versionAtLeast featureVersion "27";
  strictDeps = lib.versionAtLeast featureVersion "27";

  patches =
    lib.optionals (!atLeast23) (
      if atLeast21 then
        [
          ./21/patches/backport-ffmpeg-7-support-jfx21.patch
        ]
      else
        [
          ./17/patches/backport-ffmpeg-6-support-jfx11.patch
          ./17/patches/backport-ffmpeg-7-support-jfx11.patch

          # Build with Gradle 8
          (fetchpatch2 {
            # Yes, this patch taken from the jfx21u repo is intended to be
            # applied to jfx17.
            url = "https://github.com/openjdk/jfx21u/commit/7f704c24c2238f9d7bb744a20667a8c1337decc6.patch?full_index=1";
            excludes = [
              # The patch fails to apply to these files, but with the exception
              # of build.properties (which is patched in postPatch), none of them
              # matter.
              "build.properties"
              "gradle/legal/gradle.md"
              "gradle/wrapper/gradle-wrapper.properties"
              "gradlew"
            ];
            hash = "sha256-WuJtzPy0IV4xvn+i5xeDqekWO0VR2GIfsYKkEmh8KKU=";
          })
          # Drop GTK2 support
          (fetchpatch2 {
            url = "https://github.com/openjdk/jfx/commit/63635ee8160ba6507d625c44320b58e2f9bfb87a.patch?full_index=1";
            includes = [
              "buildSrc/linux.gradle"
            ];
            hash = "sha256-p2vRy8jA/JJBGCC5irV3gGbcJqChFNi+ViMeQ1wjtU0=";
          })
        ]
    )
    ++ lib.optionals withWebKit [
      # Building WebKit using CMake >= 4.4.0 requires patching a malformed CMake expression.
      # https://bugs.webkit.org/show_bug.cgi?id=319196
      # https://gitlab.kitware.com/cmake/cmake/-/work_items/26424
      (fetchpatch2 {
        name = "cmake4.4-linked-into-quoting.patch";
        url = "https://aur.archlinux.org/cgit/aur.git/plain/cmake4-linked-into-quoting.patch?h=webkit2gtk&id=bcf95cb5382e16354be70b0a3c88436917588c8a";
        stripLen = 1;
        extraPrefix = "modules/javafx.web/src/main/native/";
        hash = "sha256-W/sYyzrE12kEA993bfru6igiBdkyRtMiKBRjJqXN97g=";
      })
    ];

  nativeBuildInputs = [
    gradle
    perl
    pkg-config
    cmake
    gperf
    python3
    ruby
  ];

  buildInputs = [
    gtk3
    libxtst
    libxxf86vm
    glib
    alsa-lib
    (if atLeast21 then ffmpeg_7 else ffmpeg_7-headless)
  ];

  mitmCache = gradle.fetchDeps {
    attrPath = "openjfx${featureVersion}";
    pkg = pkgs."openjfx${featureVersion}".override { withWebKit = true; };
    data = ./. + "/${featureVersion}/deps.json";
  };

  gradleBuildTask = "sdk";

  stripDebugList = [ "." ];

  enableParallelBuilding = false;

  __darwinAllowLocalNetworking = true;

  # GCC 14 makes these errors by default
  env.NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types -Wno-error=int-conversion";
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
      substituteInPlace build.properties \
        --replace-fail jfx.gradle.version=7.3 jfx.gradle.version=8.4
    ''
    + lib.optionalString (lib.versionAtLeast featureVersion "27") ''
      # Gradle 9's DependencyHandler.project returns a dependency, not a Project.
      substituteInPlace build.gradle \
        --replace-fail 'testImplementation project(' 'testImplementation rootProject.project('
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
    gradle.jdk
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
    license = with lib.licenses; [
      gpl2
      classpathException20
    ];
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
}
