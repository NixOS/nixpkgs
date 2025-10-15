{
  lib,
  stdenv,
  buildPackages,
  fetchFromGitHub,
  pkg-config,
  jdk25,
  autoconf,
  cmake,
  m4,
  numactl,
  nasm,
  unzip,
  zip,
  alsa-lib,
  libjpeg,
  zlib,
  giflib,
  freetype,
  harfbuzz,
  libpng,
  lcms,
  openssl,
  cups,
  fontconfig,
  libX11,
  libICE,
  libXext,
  libXrender,
  libXtst,
  libXt,
  libXi,
  libXinerama,
  libXcursor,
  libXrandr,
  libelf,
  libdwarf,
  fetchpatch,
  perl,
  pandoc,
  gtk3,
  glib,
  file,
  ensureNewerSourcesForZipFilesHook,
  headless ? false,
  majorVersion ? 25,
  enableGtk ? true,
}:

let
  sourceFile =
    # Explicit, to make nixpkgs-vet happy
    if majorVersion == 25 then
      ./sources/25.json
    else
      throw "Unsupported Major version: ${toString majorVersion}";
  sourceData = lib.importJSON sourceFile;
  sources = lib.mapAttrs (_: fetchFromGitHub) sourceData;
  inherit (sourceData) version;
  bootstrapJdk =
    {
      "25" = jdk25;
    }
    .${toString majorVersion};
in

stdenv.mkDerivation (finalAttrs: {
  pname = "openj9${lib.optionalString headless "-headless"}";
  version = "${toString majorVersion}+${version}";

  src = sources.openjdk;

  postUnpack = ''
    cp -r --no-preserve=mode ${sources.openj9} $sourceRoot/openj9
    cp -r --no-preserve=mode ${sources.omr} $sourceRoot/omr
  '';

  patches = lib.optionals (majorVersion == 25) [
    ./patches/25/make-4.4.1.patch
    ./patches/25/openj9-version.diff
    # Fix build with libdwarf 2
    (fetchpatch {
      url = "https://github.com/eclipse-openj9/openj9-omr/commit/3619866c6c4c1b0183389fdbf18eca41e2be8f23.patch";
      hash = "sha256-4dsurJFBfkb6bd/M933sAUFpCRM29McodkOLufzwscs=";
      stripLen = 1;
      extraPrefix = "omr/";
    })
    # From "https://code.opensuse.org/package/java-25-openj9/raw/0e2817a7edf1b5134a93e082526135e45d40b7cc/f/reproducible-version.patch";
    ./patches/25/reproducible-version.patch
    # Makes java*.properties files reproducible
    ./patches/25/reproducible-nls.diff
    ./patches/25/read-truststore-from-env-jdk25.patch
  ];

  strictDeps = true;
  separateDebugInfo = true;

  dontUseCmakeConfigure = true;

  buildFlags = [ "images" ];

  __structuredAttrs = true;

  # -j flag is explicitly rejected by the build system:
  #     Error: 'make -jN' is not supported, use 'make JOBS=N'
  # Note: it does not make build sequential. Build system
  # still runs in parallel.
  enableParallelBuilding = false;

  hardeningDisable = [
    "fortify"
    "format"
  ];

  depsBuildBuild = [
    buildPackages.stdenv.cc
  ];

  nativeBuildInputs = [
    pkg-config
    autoconf
    cmake
    m4
    nasm
    unzip
    zip
    perl
    pandoc
    ensureNewerSourcesForZipFilesHook
  ];

  buildInputs = [
    alsa-lib
    libjpeg
    zlib
    giflib
    freetype
    harfbuzz
    libpng
    lcms
    openssl
    cups
    fontconfig
    libX11
    libICE
    libXext
    libXrender
    libXtst
    libXt
    libXi
    libXinerama
    libXcursor
    libXrandr
    libelf
    libdwarf
    file
  ]
  ++ lib.optionals (!headless && enableGtk) [
    gtk3
    glib
  ];

  configurePlatforms = [
    "build"
    "host"
  ];

  configureFlags = [
    # https://github.com/openjdk/jdk/blob/471f112bca715d04304cbe35c6ed63df8c7b7fee/make/autoconf/util_paths.m4#L315
    # Ignoring value of READELF from the environment. Use command line variables instead.
    "READELF=${stdenv.cc.targetPrefix}readelf"
    "AR=${stdenv.cc.targetPrefix}ar"
    "STRIP=${stdenv.cc.targetPrefix}strip"
    "NM=${stdenv.cc.targetPrefix}nm"
    "OBJDUMP=${stdenv.cc.targetPrefix}objdump"
    "OBJCOPY=${stdenv.cc.targetPrefix}objcopy"
    "--with-boot-jdk=${bootstrapJdk.home}"
    "--disable-warnings-as-errors"
    # Autodetection doesn't work for some reason
    "--with-version-feature=${toString majorVersion}"
    "--enable-unlimited-crypto"
    "--with-native-debug-symbols=internal"
    "--with-stdc++lib=dynamic"
    "--with-zlib=system"
    "--with-giflib=system"
    "--with-version-string=${version}"
    "--with-vendor-version-string=(nix)"
    "--with-version-opt=nixos"
    "--with-freetype=system"
    "--with-harfbuzz=system"
    "--with-libjpeg=system"
    "--with-libpng=system"
    "--with-lcms=system"
    "--with-openssl=system"
  ]
  ++ lib.optional headless "--enable-headless-only";

  env = {
    NIX_CFLAGS_COMPILE = "-I${lib.getDev numactl}/include -Wno-error";
    NIX_LDFLAGS = lib.concatStringsSep " " (
      lib.optionals (!headless) [
        "-lfontconfig"
        "-lcups"
        "-lXinerama"
        "-lXrandr"
        "-lmagic"
      ]
      ++ lib.optionals (!headless && enableGtk) [
        "-lgtk-3"
        "-lgio-2.0"
      ]
    );
  };

  preConfigure =
    # Set number of jobs to use when building.
    ''
      configureFlags+=("--with-jobs=''${NIX_BUILD_CORES}")
    '';

  doCheck = false;

  postPatch = ''
    chmod +x configure
    patchShebangs --build configure
    chmod +x make/scripts/*.{template,sh,pl}
    patchShebangs --build make/scripts

    substituteInPlace closed/autoconf/custom-hook.m4 \
      --replace-fail '/usr/include/numa.h' '${lib.getDev numactl}/include/numa.h' \
      --replace-fail '/usr/include/numaif.h' '${lib.getDev numactl}/include/numaif.h'

    substituteInPlace closed/OpenJ9.gmk \
      --replace-fail 'OPENJ9_TAG := $(shell $(GIT) -C $(OPENJ9_TOPDIR) describe --exact-match HEAD 2>/dev/null)' 'OPENJ9_TAG := ${sources.openjdk.tag}'
  '';

  installPhase = ''
    mkdir -p $out/lib
    mv build/*/images/jdk $out/lib/openjdk
  ''
  # Remove some broken manpages.
  + ''
    rm -rf $out/lib/openjdk/man/ja*
  ''
  # Mirror some stuff in top-level.
  + ''
    mkdir -p $out/share
    ln -s $out/lib/openjdk/bin $out/bin
    ln -s $out/lib/openjdk/include $out/include
    ln -s $out/lib/openjdk/man $out/share/man
  ''
  # IDEs use the provided src.zip to navigate the Java codebase (https://github.com/NixOS/nixpkgs/pull/95081)
  + ''
    ln -s $out/lib/openjdk/lib/src.zip $out/lib/src.zip
  ''
  # jni.h expects jni_md.h to be in the header search path.
  + ''
    ln -s $out/include/linux/*_md.h $out/include/
  ''
  # Remove crap from the installation.
  + ''
    rm -rf $out/lib/openjdk/demo
  ''
  + lib.optionalString headless ''
    rm $out/lib/openjdk/lib/{libjsound,libfontmanager}.so
  '';

  preFixup =
    # Set JAVA_HOME automatically.
    ''
      mkdir -p $out/nix-support
      cat <<EOF > $out/nix-support/setup-hook
      if [ -z "\''${JAVA_HOME-}" ]; then export JAVA_HOME=$out/lib/openjdk; fi
      EOF
    '';

  disallowedReferences = [ bootstrapJdk ];

  passthru = {
    home = "${finalAttrs.finalPackage}/lib/openjdk";
  };

  meta = {
    description = "Java Development Kit ${toString majorVersion} with Eclipse OpenJ9 JVM implemenation";
    homepage = "https://eclipse.dev/openj9/";
    license = with lib.licenses; [
      gpl2Only
      classpathException20
    ];
    maintainers = with lib.maintainers; [
      marie
    ];
    platforms = lib.platforms.linux;
    mainProgram = "java";
  };
})
