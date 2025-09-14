{
  lib,
  cctools,
  cmake,
  darwin,
  fetchFromGitHub,
  libtapi,
  llvm,
  libxml2,
  meson,
  ninja,
  openssl,
  pkg-config,
  stdenv,
  xar,
}:

let
  # Copy the files from their original sources instead of using patches to reduce the size of the patch set in nixpkgs.
  otherSrcs = {
    # The last version of ld64 to have dyldinfo
    ld64 = fetchFromGitHub {
      owner = "apple-oss-distributions";
      repo = "ld64";
      tag = "ld64-762";
      hash = "sha256-UIq/fwO40vk8yvoTfx+UlLhnuzkI0Ih+Ym6W/BwnP0s=";
    };

    # Provides the source files used in the vendored libtapi. The libtapi derivation puts `tapi-src` first.
    libtapi = lib.head libtapi.srcs;
  };

  ld64src = lib.escapeShellArg "${otherSrcs.ld64}";
  libtapisrc = lib.escapeShellArg "${otherSrcs.libtapi}";

  llvmPath = "${lib.getLib llvm}";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "ld64";
  version = "954.16";

  outputs = [
    "out"
    "dev"
    "lib"
  ];

  src = fetchFromGitHub {
    owner = "apple-oss-distributions";
    repo = "ld64";
    tag = "ld64-${finalAttrs.version}";
    hash = "sha256-CVIyL2J9ISZnI4+r+wp4QtOb3+3Tmz2z2Z7/qeRqHS0=";
  };

  patches = [
    # These patches are vendored from https://github.com/reckenrode/ld64/tree/ld64-951.9-nixpkgs.
    # See their comments for more on what they do.
    ./patches/0001-Always-use-write-instead-of-mmap.patch
    ./patches/0002-Add-compile_stubs.h-using-Clang-s-embed-extension-fo.patch
    ./patches/0003-Inline-missing-definitions-instead-of-using-private-.patch
    ./patches/0004-Removed-unused-Blob-clone-method.patch
    ./patches/0005-Use-std-atomics-and-std-mutex-for-portability.patch
    ./patches/0006-Add-Meson-build-system.patch
    ./patches/0007-Add-CrashReporterClient-header.patch
    ./patches/0008-Provide-mach-compatibility-headers-based-on-LLVM-s-h.patch
    ./patches/0009-Support-LTO-in-nixpkgs.patch
    ./patches/0010-Add-vendored-libtapi-to-the-ld64-build.patch
    ./patches/0011-Modify-vendored-libtapi-to-build-with-upstream-LLVM.patch
    ./patches/0012-Move-libcodedirectory-to-its-own-subproject.patch
    ./patches/0013-Set-the-version-string-in-the-build.patch
    ./patches/0014-Replace-corecrypto-and-CommonCrypto-with-OpenSSL.patch
    ./patches/0015-Add-libcd_is_blob_a_linker_signature-implementation.patch
    ./patches/0016-Add-dyldinfo-to-the-ld64-build.patch
    ./patches/0017-Fix-dyldinfo-build.patch
    ./patches/0018-Use-STL-containers-instead-of-LLVM-containers.patch
  ];

  prePatch = ''
    # Copy dyldinfo source files
    cp ${ld64src}/doc/man/man1/dyldinfo.1 doc/man/man1/dyldinfo.1
    cp ${ld64src}/src/other/dyldinfo.cpp src/other/dyldinfo.cpp

    # Copy files needed from libtapi by ld64
    mkdir -p subprojects/libtapi/tapi
    cp ${libtapisrc}/tools/libtapi/*.cpp subprojects/libtapi
    cp ${libtapisrc}/LICENSE.TXT subprojects/libtapi/LICENSE.TXT

    declare -a tapiHeaders=(
      APIVersion.h
      Defines.h
      LinkerInterfaceFile.h
      PackedVersion32.h
      Symbol.h
      Version.h
      Version.inc.in
      tapi.h
    )
    for header in "''${tapiHeaders[@]}"; do
      cp ${libtapisrc}/include/tapi/$header subprojects/libtapi/tapi/$header
    done
  '';

  xcodeHash = "sha256-qip/1eiGn8PdLThonhPq3oq2veN4E1zOiamDPBfTeNE=";
  xcodeProject = "ld64.xcodeproj";

  nativeBuildInputs = [
    cmake
    darwin.xcodeProjectCheckHook
    meson
    ninja
    openssl
    pkg-config
  ];

  buildInputs = [
    llvm
    libxml2
    openssl
    xar
  ];

  dontUseCmakeConfigure = true; # CMake is only needed because it’s used by Meson to find LLVM.

  # Note for overrides: ld64 cannot be built as a debug build because of UB in its iteration implementations,
  # which trigger libc++ debug assertions due to trying to take the address of the first element of an empty vector.
  mesonBuildType = "release";

  mesonFlags = [
    (lib.mesonOption "b_ndebug" "if-release")
    (lib.mesonOption "default_library" (if stdenv.hostPlatform.isStatic then "static" else "shared"))
    (lib.mesonOption "libllvm_path" llvmPath)
  ];

  doInstallCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  # ld64 has a test suite, but many of the tests fail (even with ld from Xcode). Instead
  # of running the test suite, rebuild ld64 using itself to link itself as a check.
  # LTO is enabled only to confirm that it is set up and working properly in nixpkgs.
  installCheckPhase = ''
    runHook preInstallCheck

    cd "$NIX_BUILD_TOP/$sourceRoot"

    export NIX_CFLAGS_COMPILE+=" --ld-path=$out/bin/ld"
    export NIX_CFLAGS_LINK+=" -L$SDKROOT/usr/lib"
    meson setup build-install-check --buildtype=$mesonBuildType ${
      lib.escapeShellArgs [
        (lib.mesonBool "b_lto" true)
        (lib.mesonOption "libllvm_path" llvmPath)
      ]
    }

    cd build-install-check
    ninja src/ld/ld "-j$NIX_BUILD_CORES"

    # Confirm that ld found the LTO library and reports it.
    if ./src/ld/ld -v 2>&1 | grep -q 'LTO support'; then
        echo "LTO: supported"
    else
        echo "LTO: not supported" && exit 1
    fi

    runHook postInstallCheck
  '';

  postInstall = ''
    ln -s ld-classic.1 "$out/share/man/man1/ld.1"
    ln -s ld.1 "$out/share/man/man1/ld64.1"
    moveToOutput lib/libprunetrie.a "$dev"
  '';

  __structuredAttrs = true;

  meta = {
    description = "Classic linker for Darwin";
    homepage = "https://opensource.apple.com/releases/";
    license = lib.licenses.apple-psl20;
    mainProgram = "ld";
    teams = [ lib.teams.darwin ];
    platforms = lib.platforms.darwin; # Porting to other platforms is incomplete. Support only Darwin for now.
  };
})
