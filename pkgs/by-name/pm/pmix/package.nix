{
  lib,
  stdenv,
  fetchFromGitHub,
  perl,
  autoconf,
  automake,
  removeReferencesTo,
  libtool,
  python3,
  flex,
  libevent,
  targetPackages,
  makeWrapper,
  hwloc,
  munge,
  zlib,
  gitMinimal,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pmix";
  version = "6.1.0";

  src = fetchFromGitHub {
    repo = "openpmix";
    owner = "openpmix";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wMVppqSXpQeBgkwna+jaU5kY03WHbGwMQQrouCyGROo=";
    fetchSubmodules = true;
  };

  outputs = [
    "out"
    "dev"
  ];

  postPatch = ''
    patchShebangs --build ./autogen.pl
    patchShebangs --build ./config
    patchShebangs --build ./contrib
    patchShebangs --build ./src/util/convert-help.py

  ''
  # 1. Remove the build information (options to configure and the CC path)
  # These are hardcoded in the library and create an unwanted dependency
  # on *.dev inputs.
  # 2. Remove the reference to the pmix include directories, which are
  # also hardcoded into the library (would be a cyclic reference).
  + ''
    substituteInPlace ./src/runtime/pmix_info_support.c \
      --replace-fail 'PMIX_CONFIGURE_CLI' '""' \
      --replace-fail 'PMIX_CC_ABSOLUTE' '""'

    substituteInPlace ./src/mca/pinstalldirs/config/pinstall_dirs.h.in \
      --replace-fail '@includedir@' ""
  '';

  nativeBuildInputs = [
    perl
    autoconf
    automake
    libtool
    flex
    gitMinimal
    python3
    removeReferencesTo
    makeWrapper
  ];

  buildInputs = [
    libevent
    hwloc
    munge
    zlib
  ];

  configureFlags = [
    "--with-libevent=${lib.getDev libevent}"
    "--with-libevent-libdir=${lib.getLib libevent}/lib"
    "--with-munge=${lib.getDev munge}"
    "--with-munge-libdir=${lib.getLib munge}/lib"
    "--with-hwloc=${lib.getDev hwloc}"
    "--with-hwloc-libdir=${lib.getLib hwloc}/lib"
  ];

  preConfigure = ''
    ./autogen.pl
  '';

  postInstall = ''
    find $out/lib/ -name "*.la" -exec rm -f \{} \;

    moveToOutput "bin/pmix_info" "''${!outputDev}"
    moveToOutput "bin/pmixcc" "''${!outputDev}"
    moveToOutput "share/pmix/pmixcc-wrapper-data.txt" "''${!outputDev}"

  ''
  # From some reason the Darwin build doesn't include this file, so we
  # currently disable this substitution for any non-Linux platform, until a
  # Darwin user will care enough about this cross platform fix.
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    # Pin the compiler to the current version in a cross compiler friendly way.
    # Same pattern as for openmpi (see https://github.com/NixOS/nixpkgs/pull/58964#discussion_r275059427).
    substituteInPlace "''${!outputDev}"/share/pmix/pmixcc-wrapper-data.txt \
      --replace-fail compiler=${stdenv.cc.targetPrefix}gcc \
        compiler=${targetPackages.stdenv.cc}/bin/${targetPackages.stdenv.cc.targetPrefix}cc
  '';

  postFixup = lib.optionalString (lib.elem "dev" finalAttrs.outputs) ''
    # The path to the pmixcc-wrapper-data.txt is hard coded and
    # points to $out instead of dev. Use wrapper to fix paths.
    wrapProgram "''${!outputDev}"/bin/pmixcc \
      --set PMIX_INCLUDEDIR "''${!outputDev}"/include \
      --set PMIX_PKGDATADIR "''${!outputDev}"/share/pmix
  '';

  enableParallelBuilding = true;

  meta = {
    description = "Process Management Interface for HPC environments";
    homepage = "https://openpmix.github.io/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      markuskowa
      doronbehar
    ];
  };
})
