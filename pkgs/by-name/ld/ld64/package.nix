{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  darwin,
  libtapi,
  libunwind,
  llvm,
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
  # The targetPrefix is prepended to binary names to allow multiple binutils on the PATH to be usable.
  targetPrefix = lib.optionalString (
    stdenv.targetPlatform != stdenv.hostPlatform
  ) "${stdenv.targetPlatform.config}-";

  # ld64 needs CrashReporterClient.h, which is hard to find, but WebKit2 has it.
  # Fetch it directly because the Darwin stdenv bootstrap can’t depend on fetchgit.
  crashreporter_h = fetchurl {
    url = "https://raw.githubusercontent.com/apple-oss-distributions/WebKit2/WebKit2-7605.1.33.0.2/Platform/spi/Cocoa/CrashReporterClientSPI.h";
    hash = "sha256-0ybVcwHuGEdThv0PPjYQc3SW0YVOyrM3/L9zG/l1Vtk=";
  };

  # First version with all the required definitions. This is used in preference to darwin.xnu to make it easier
  # to support Linux and because the version of darwin.xnu available on x86_64-darwin in the 10.12 SDK is too old.
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

  xcodeHash = "sha256-+j7Ed/6aD46SJnr3DWPfWuYWylb2FNJRPmWsUVxZJHM=";

  postUnpack = ''
    unpackFile '${xnu}'

    # Verify that the Xcode project has not changed unexpectedly.
    hashType=$(echo $xcodeHash | cut -d- -f1)
    expectedHash=$(echo $xcodeHash | cut -d- -f2)
    hash=$(openssl "$hashType" -binary "$sourceRoot/ld64.xcodeproj/project.pbxproj" | base64)

    if [ "$hash" != "$expectedHash" ]; then
      echo 'error: hash mismatch in ld64.xcodeproj/project.pbxproj'
      echo "        specified: $xcodeHash"
      echo "           got:    $hashType-$hash"
      echo
      echo 'Upstream Xcode project has changed. Update `meson.build` with any changes, then update `xcodeHash`.'
      echo 'Use `nix-hash --flat --sri --type sha256 ld64.xcodeproj/project.pbxproj` to regenerate it.'
      exit 1
    fi
  '';

  patches = [
    # Use std::atomic for atomics. Replaces private APIs (`os/lock_private.h`) with standard APIs.
    ./0004-Use-std-atomics-and-std-mutex.patch
    # ld64 assumes the default libLTO.dylib can be found relative to its bindir, which is
    # not the case in nixpkgs. Override it to default to `stdenv.cc`’s libLTO.dylib.
    ./0005-Support-LTO-in-nixpkgs.patch
    # Add implementation of missing function required for code directory support.
    ./0006-Add-libcd_is_blob_a_linker_signature-implementation.patch
    # Add OpenSSL implementation of CoreCrypto digest functions. Avoids use of private and non-free APIs.
    ./0007-Add-OpenSSL-based-CoreCrypto-digest-functions.patch
    # ld64 will search `/usr/lib`, `/Library/Frameworks`, etc by default. Disable that.
    ./0008-Disable-searching-in-standard-library-locations.patch
  ];

  postPatch = ''
    substitute ${./meson.build} meson.build \
      --subst-var version
    cp ${./meson.options} meson.options

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
    openssl
    pkg-config
    python3
  ];

  buildInputs =
    [
      libtapi
      llvm
      libunwind
      openssl
      xar
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ darwin.dyld ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ libdispatch ];

  # Note for overrides: ld64 cannot be built as a debug build because of UB in its iteration implementations,
  # which trigger libc++ debug assertions due to trying to take the address of the first element of an emtpy vector.
  mesonBuildType = "release";

  mesonFlags = [
    (lib.mesonOption "b_ndebug" "if-release")
    (lib.mesonOption "default_library" (if stdenv.hostPlatform.isStatic then "static" else "shared"))
  ] ++ lib.optionals (targetPrefix != "") [ (lib.mesonOption "target_prefix" targetPrefix) ];

  doInstallCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  # ld64 has a test suite, but many of the tests fail (even with ld from Xcode). Instead
  # of running the test suite, rebuild ld64 using itself to link itself as a check.
  # LTO is enabled only to confirm that it is set up and working properly in nixpkgs.
  installCheckPhase = ''
    runHook preInstallCheck

    cd "$NIX_BUILD_TOP/$sourceRoot"

    export NIX_CFLAGS_COMPILE+=" --ld-path=$out/bin/${targetPrefix}ld"
    meson setup build-install-check -Db_lto=true --buildtype=$mesonBuildType${
      lib.optionalString (targetPrefix != "") " -Dtarget_prefix=${targetPrefix}"
    }

    cd build-install-check
    ninja ${targetPrefix}ld "-j$NIX_BUILD_CORES"

    # Confirm that ld found the LTO library and reports it.
    ./${targetPrefix}ld -v 2>&1 | grep -q 'LTO support'

    runHook postInstallCheck
  '';

  postInstall = ''
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
    platforms = lib.platforms.darwin; # Porting to other platforms is incomplete. Support only Darwin for now.
  };
})
