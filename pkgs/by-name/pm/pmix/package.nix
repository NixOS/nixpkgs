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
  pandoc,
  gitMinimal,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pmix";
  version = "5.0.3";

  src = fetchFromGitHub {
    repo = "openpmix";
    owner = "openpmix";
    rev = "v${finalAttrs.version}";
    hash = "sha256-5qBZj4L0Qu/RvNj8meL0OlLCdfGvBP0D916Mr+0XOCQ=";
    fetchSubmodules = true;
  };

  outputs = [ "out" ] ++ lib.optionals stdenv.hostPlatform.isLinux [ "dev" ];

  postPatch = ''
    patchShebangs ./autogen.pl
    patchShebangs ./config
  '';

  nativeBuildInputs = [
    pandoc
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
    "--with-munge=${munge}"
    "--with-hwloc=${lib.getDev hwloc}"
    "--with-hwloc-libdir=${lib.getLib hwloc}/lib"
  ];

  preConfigure = ''
    ./autogen.pl
  '';

  postInstall =
    ''
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
        --replace-fail compiler=gcc \
          compiler=${targetPackages.stdenv.cc}/bin/${targetPackages.stdenv.cc.targetPrefix}cc
    '';

  postFixup = lib.optionalString (lib.elem "dev" finalAttrs.outputs) ''
    # The build info (parameters to ./configure) are hardcoded
    # into the library. This clears all references to $dev/include.
    remove-references-to -t "''${!outputDev}" $(readlink -f $out/lib/libpmix.so)

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
