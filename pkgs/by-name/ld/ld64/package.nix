{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  darwin,
  libtapi,
  libunwind,
  llvm,
  llvmPackages,
  meson,
  ninja,
  openssl,
  pkg-config,
  python3,
  swiftPackages,
  xar,
  gitUpdater,
}:

let
  # The targetPrefix is prepended to binary names to allow multiple binuntils on the PATH to both be usable.
  targetPrefix = lib.optionalString (stdenv.targetPlatform != stdenv.hostPlatform) "${stdenv.targetPlatform.config}-";

  # ld64 needs CrashReporterClient.h, which is hard to find, but WebKit2 has it.
  # Fetch it directly because the Darwin stdenv bootstrap can’t depend on fetchgit.
  crashreporter_h = fetchurl {
    url = "https://raw.githubusercontent.com/apple-oss-distributions/WebKit2/WebKit2-7605.1.33.0.2/Platform/spi/Cocoa/CrashReporterClientSPI.h";
    hash = "sha256-0ybVcwHuGEdThv0PPjYQc3SW0YVOyrM3/L9zG/l1Vtk=";
  };
  # First version with all the required definitions
  xnu = fetchFromGitHub {
    name = "xnu-src";
    owner = "apple-oss-distributions";
    repo = "xnu";
    rev = "xnu-6153.11.26";
    hash = "sha256-dcnGcp7bIjQxeAn5pXt+mHSYEXb2Ad9Smhd/WUG4kb4=";
  };
  # Avoid pulling in all of Swift just to build libdispatch
  libdispatch = swiftPackages.Dispatch.override { useSwift = false; };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "ld64";
  version = "951.9";

  outputs = [
    "out"
    "dev"
    "lib"
  ];

  src = fetchFromGitHub {
    owner = "apple-oss-distributions";
    repo = "ld64";
    rev = "ld64-${finalAttrs.version}";
    hash = "sha256-hLkfqgBwVPlO4gfriYOawTO5E1zSD63ZcNetm1E5I70";
  };

  sourceRoot = "source";

  postUnpack = ''
    unpackFile '${xnu}'
  '';

  patches = [
    # Use std::atomic for atomics.
    ./0001-Use-std-atomics-and-std-mutex.patch
    # `&vec[0]` is UB if the vector is empty. vec.data() is a safe replacement as long as
    # the pointer is not dereferenced.
    ./0002-Avoid-UB-when-std-vector-is-empty.patch
    # ld64 assumes the default libLTO.dylib can be found relative to its bindir, which is
    # not the case in nixpkgs. Override it to default to `stdenv.cc`’s libLTO.dylib.
    ./0003-Support-LTO-in-nixpkgs.patch
    # Add implementation of missing function required for code directory support.
    ./0004-Add-libcd_is_blob_a_linker_signature-implementation.patch
    # Add OpenSSL implementation of CoreCrypto digest functions
    ./0005-Add-OpenSSL-based-CoreCrypto-digest-functions.patch
    # ld64 will search `/usr/lib`, `/Library/Frameworks`, etc by default. Disable that.
    ./0006-Disable-searching-in-standard-library-locations.patch
  ];

  postPatch = ''
    substitute ${./meson.build} meson.build \
      --subst-var-by targetPrefix '${targetPrefix}' \
      --subst-var version

    # Copy headers for certain private APIs
    mkdir -p include
    substitute ${crashreporter_h} include/CrashReporterClient.h \
      --replace-fail 'USE(APPLE_INTERNAL_SDK)' '0'

    # Copy from the source so the headers can be used on Linux and x86_64-darwin
    mkdir -p include/System
    for dir in arm i386 machine; do
      cp -r ../xnu-src/osfmk/$dir include/System/$dir
    done
    mkdir -p include/sys
    cp ../xnu-src/bsd/sys/commpage.h include/sys

    # Match the version format used by upstream.
    sed -i src/ld/Options.cpp \
      -e '1iconst char ld_classicVersionString[] = "@(#)PROGRAM:ld PROJECT:ld64-${finalAttrs.version}\\n";'

    # Instead of messing around with trying to extract and run the script from the Xcode project,
    # just use our own Python script to generate `compile_stubs.h`
    cp ${./gen_compile_stubs.py} gen_compile_stubs.py

    # Enable LTO support using LLVM’s libLTO.dylib by default.
    substituteInPlace src/ld/InputFiles.cpp \
      --subst-var-by libllvm '${lib.getLib llvm}'
    substituteInPlace src/ld/parsers/lto_file.cpp \
      --subst-var-by libllvm '${lib.getLib llvm}'

    # Use portable includes
    substituteInPlace src/ld/code-sign-blobs/endian.h \
      --replace-fail '#include <machine/endian.h>' '#include <sys/types.h>'
  '';

  strictDeps = true;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3
  ];

  buildInputs = [
    libtapi
    llvm
    libunwind
    openssl
    xar
  ] ++ lib.optionals stdenv.isDarwin [ darwin.dyld ] ++ lib.optionals stdenv.isLinux [ libdispatch ];

  mesonBuildType = "release";

  mesonFlags = [
    (lib.mesonOption "b_ndebug" "if-release")
    (lib.mesonOption "default_library" (if stdenv.hostPlatform.isStatic then "static" else "shared"))
  ] ++ lib.optionals finalAttrs.doCheck [
    (lib.mesonBool "b_lto" true)
  ];

  # ld64 has a test suite, but many of the tests fail (even with ld from Xcode). Instead
  # of running the test suite, rebuild ld64 using itself to link itself as a check.
  preConfigure = lib.optionalString finalAttrs.doCheck ''
    pushd . > /dev/null

    meson setup build-bootstrap -Db_lto=false --buildtype=''${mesonBuildType:-plain}

    cd build-bootstrap
    ninja ${targetPrefix}ld "-j$NIX_BUILD_CORES"

    # use `$NIX_CFLAGS_COMPILE` to make sure Meson picks up the new linker.
    export NIX_CFLAGS_COMPILE+=" --ld-path=$PWD/${targetPrefix}ld"

    popd > /dev/null
  '';

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;
  dontMesonCheck = true;

  postInstall = ''
    ln -s '${targetPrefix}unwinddump' "$out/bin/${targetPrefix}dwarfdump"
    ln -s unwinddump.1 "$out/share/man/man1/dwarfdump.1"
    ln -s ld-classic.1 "$out/share/man/man1/ld.1"
    ln -s ld.1 "$out/share/man/man1/ld64.1"
    moveToOutput lib/libprunetrie.a "$dev"
  '';

  __structuredAttrs = true;

  passthru.updateScript = gitUpdater { rev-prefix = "ld64-"; };

  meta = {
    description = "The classic linker for Darwin";
    homepage = "https://opensource.apple.com/releases/";
    license = lib.licenses.apple-psl20;
    mainProgram = "ld";
    maintainers = with lib.maintainers; [ reckenrode ];
    platforms = lib.platforms.unix;
  };
})
