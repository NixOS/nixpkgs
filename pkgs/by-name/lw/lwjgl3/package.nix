{
  lib,
  stdenv,
  ant,
  buildPackages,
  callPackage,
  dbus,
  fetchFromGitHub,
  glib,
  gtk3,
  kotlin,
  libGL,
  libffi,
  pkg-config,
  pkgsCross,
  stripJavaArchivesHook,
}:

let
  isCross = stdenv.buildPlatform != stdenv.hostPlatform;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "lwjgl";
  version = "3.3.6";

  src = fetchFromGitHub {
    owner = "LWJGL";
    repo = "lwjgl3";
    tag = finalAttrs.version;
    hash = "sha256-iXwsTo394uoq8/jIlfNuQlXW1lnuge+5/+00O4UdvyA=";
  };

  patches = [
    ./patches/0001-build-use-pkg-config-for-linux-dependencies.patch
    ./patches/0002-build-allow-local-kotlin.patch
    ./patches/0003-build-allow-linking-against-system-libffi.patch
    ./patches/0004-build-add-dbus-as-dependency-for-nfd_portal.patch
    ./patches/0005-build-allow-setting-pkg-config-prefix-suffix.patch
  ];

  antJdk = buildPackages.jdk_headless;
  antDeps = finalAttrs.finalPackage.fetchAntDeps {
    inherit (finalAttrs)
      pname
      version
      src
      patches
      antJdk
      antFlags
      ;

    hash = "sha256-n2ON2eMBWZbu4A2yPBR4wN17dpWkBrf+1nq2l4uK3yk=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    ant
    kotlin
    pkg-config
    stripJavaArchivesHook
  ];

  buildInputs = [
    dbus
    glib
    gtk3
    libffi
  ];

  antTargets = [
    "compile-templates"
    "compile-native"
  ];

  antFlags =
    [
      "-Dgcc.libpath.opengl=${lib.getLib libGL}/lib"

      # Don't bundle javadoc, else ant will try to grab a favicon from lwjgl.org
      # It also slows down builds
      # https://github.com/LWJGL/lwjgl3/blob/5bd237c53774aa52703b35cc2e692d7113db2bca/build.xml#L1372C36-L1372C55
      "-Djavadoc.skip=true"

      "-Dlibffi.path=${lib.getLib libffi}/lib"
      "-Duse.libffi.so=true"

      "-Dlocal.kotlin=${lib.getBin kotlin}"
    ]
    ++ lib.optionals (!isCross) [
      "-Dgcc.prefix="
      "-Dpkg-config.prefix="
    ]
    ++ lib.optionals isCross [
      "-Dgcc.prefix=${stdenv.cc.targetPrefix}"
      "-Dpkg-config.prefix=${stdenv.cc.targetPrefix}"
    ];

  env = {
    JAVA_HOME = finalAttrs.antJdk.home;
    JAVA8_HOME = buildPackages.jdk8_headless.home;

    LWJGL_BUILD_OFFLINE = "yes";
    LWJGL_BUILD_TYPE = "release/${finalAttrs.version}";
  };

  # Put the dependencies we already downloaded in the right place
  # NOTE: This directory *must* be writable
  configurePhase = ''
    runHook preConfigure

    mkdir -p bin
    cp -dpr "$antDeps" bin/libs && chmod -R +w bin/libs

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    concatTo flagsArray buildFlags buildFlagsArray antTargets antFlags
    ant "''${flagsArray[@]}"

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib

    find bin/ \
      -type f \
      -name '*.so' \
      -exec install -Dm755 -t $out/lib {} \;

    runHook postInstall
  '';

  passthru = {
    # fetcher-y thing for LWJGL's homegrown dependency management
    fetchAntDeps = callPackage ./fetch-ant-deps.nix { };

    tests = lib.optionalAttrs stdenv.hostPlatform.isLinux {
      cross-aarch64 = pkgsCross.aarch64-multiplatform.lwjgl3;
    };
  };

  meta = {
    description = "Lightweight Java Game Library";
    homepage = "https://www.lwjgl.org/";
    changelog = "https://github.com/LWJGL/lwjgl3/releases/tag/${toString finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ getchoo ];
    platforms = lib.platforms.linux;
  };
})
