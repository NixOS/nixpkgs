{
  stdenv,
  fetchFromGitHub,
  fetchurl,
  lib,
  which,
  git,
  zip,
  nasm,
  acpica-tools,
  libuuid,
  python3,
  procps,
  unzip,
}:

let
  buildTarget = "DEBUG";
  targetArch =
    if stdenv.hostPlatform.isi686 then
      "IA32"
    else if stdenv.hostPlatform.isx86_64 then
      "X64"
    else
      throw "Unsupported architecture";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "opencore";
  version = "1.0.6";

  src = fetchFromGitHub {
    owner = "acidanthera";
    repo = "OpenCorePkg";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-Q1dYZm9QS4HgPxBf56LyS5t2sk2A64s1g8A8PNujYcw=";
  };

  audk = fetchFromGitHub {
    owner = "acidanthera";
    repo = "audk";
    rev = "82f2f9fc6cac1115727b8d62507ce972b205db3a";
    fetchSubmodules = true;
    leaveDotGit = true;
    hash = "sha256-piwazCn0y+HWT9L+k9Ghk7sPZzVUYCXAtNEYXh1fG8g=";
  };

  efibuild = fetchurl {
    url = "https://raw.githubusercontent.com/acidanthera/ocbuild/7138bdcd2d986972e509592ded562bb70f3fac28/efibuild.sh";
    hash = "sha256-uzIDgaiWEDcv8OPaDE7sP4olQ48wO9mRvt5qmItNCiY=";
  };

  unpackPhase = ''
    runHook preUnpack

    cp -r ${finalAttrs.src} OpenCorePkg
    chmod -R u+w OpenCorePkg
    cp -r ${finalAttrs.audk} OpenCorePkg/UDK
    chmod -R u+w OpenCorePkg/UDK

    runHook postUnpack
  '';

  patchPhase = ''
    runHook prePatch

    # Make build_oc.tool use the local efibuild.sh instead of fetching it
    patchShebangs OpenCorePkg/build_oc.tool
    substituteInPlace OpenCorePkg/build_oc.tool \
      --replace-fail \
        'curl -LfsS https://raw.githubusercontent.com/acidanthera/ocbuild/master/efibuild.sh' \
        "cat ${finalAttrs.efibuild}"

    # Otherwise efibuild.sh will delete it
    touch OpenCorePkg/UDK/UDK.ready

    # Disable LTO in BaseTools makefiles
    sed -i 's/-flto//g' OpenCorePkg/UDK/BaseTools/Source/C/Makefiles/*.makefile

    # CRITICAL: Disable LTO in OpenCorePkg.dsc build options
    sed -i 's/-flto//g' OpenCorePkg/OpenCorePkg.dsc

    # Also remove -Oz optimization that can cause issues
    #sed -i 's/-Oz/-O2/g' OpenCorePkg/OpenCorePkg.dsc

    # /usr/bin/env referenced during test run
    patchShebangs OpenCorePkg/UDK/BaseTools/BinWrappers/PosixLike/*

    # later on in the build
    patchShebangs OpenCorePkg/Library/OcConfigurationLib/CheckSchema.py

    runHook postPatch
  '';

  buildInputs = [
    which
    git
    zip
    nasm
    acpica-tools
    python3
    procps
    unzip
  ];

  hardeningDisable = [
    "fortify"
    "format"
  ];

  nativeBuildInputs = [
    libuuid
  ];

  # Set the compiler prefix as EDK2 expects
  ${"GCC5_${targetArch}_PREFIX"} = stdenv.cc.targetPrefix;

  buildPhase = ''
    runHook preBuild

    cd OpenCorePkg

    export OFFLINE_MODE=1
    export NIX_CFLAGS_COMPILE="-std=gnu11 -Wno-error=maybe-uninitialized -Wno-error=stringop-overflow -Wno-error=format $NIX_CFLAGS_COMPILE"
    export TOOLCHAINS=GCC
    export ARCHS=${targetArch}
    export TARGETS=${buildTarget}

    # Force single-threaded build for OpenSSL compilation
    #export MAX_CONCURRENT_THREAD_NUMBER=1

    bash -x ./build_oc.tool

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    unzip Binaries/OpenCore-${finalAttrs.version}-${buildTarget}.zip -d $out

    runHook postInstall
  '';

  meta = {
    description = "Modular UEFI bootloader for multiple operating systems";
    homepage = "https://github.com/acidanthera/OpenCorePkg";
    license = lib.licenses.bsd3;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ jonhermansen ];
  };
})
