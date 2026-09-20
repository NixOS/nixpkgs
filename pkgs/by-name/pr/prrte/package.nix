{
  lib,
  stdenv,
  removeReferencesTo,
  fetchFromGitHub,
  autoconf,
  automake,
  libtool,
  pkg-config,
  gitMinimal,
  perl,
  python3,
  flex,
  hwloc,
  libevent,
  zlib,
  pmix,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "prrte";
  version = "4.1.0";

  src = fetchFromGitHub {
    owner = "openpmix";
    repo = "prrte";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FO2dFqvJ3Ahc7rE2gAiQhmM5GTc7LJ8nE4y5fe+FgDg=";
    fetchSubmodules = true;
  };

  outputs = [
    "out"
    "dev"
  ];

  postPatch = ''
    patchShebangs ./autogen.pl ./config

    # This is needed for multi-node jobs.
    # mpirun/srun/prterun does not have "prted" in its path unless
    # it is actively pulled in. Hard-coding the nix store path
    # as a default universally solves this issue.
    substituteInPlace src/runtime/prte_mca_params.c --replace-fail \
      "prte_launch_agent = \"prted\"" "prte_launch_agent = \"$out/bin/prted\""
  '';

  preConfigure = ''
    ./autogen.pl
    patchShebangs --build ./src/util/prte-convert-help.py
  '';

  postInstall = ''
    moveToOutput "bin/prte_info" "''${!outputDev}"
    moveToOutput "bin/prte-info" "''${!outputDev}"
    # Fix a broken symlink, created due to FHS assumptions
    # The upstream configure probe cannot run HOST pmixcc when cross-compiling,
    # so it may omit this optional symlink.
    rm -f "$out/bin/pcc"
    ln -s ${lib.getDev pmix}/bin/pmixcc "''${!outputDev}"/bin/pcc

    remove-references-to -t "''${!outputDev}" $(readlink -f $out/lib/libprrte${stdenv.hostPlatform.extensions.library})
  '';

  nativeBuildInputs = [
    removeReferencesTo
    perl
    python3
    autoconf
    automake
    libtool
    flex
    gitMinimal
    pkg-config
  ];

  buildInputs = [
    libevent
    hwloc
    zlib
    pmix
  ];

  # PMIx's pkg-config file is in dev; it supplies the separate library output.
  configureFlags = [
    "--with-pmix=${lib.getDev pmix}"
  ];

  # The generated libtool would otherwise try to run HOST ldconfig on BUILD.
  ${if stdenv.buildPlatform != stdenv.hostPlatform then "installFlags" else null} = [
    "LIBTOOLFLAGS=--no-finish"
  ];

  enableParallelBuilding = true;

  meta = {
    description = "PMIx Reference Runtime Environment";
    homepage = "https://docs.prrte.org/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ markuskowa ];
    platforms = lib.platforms.unix;
  };
})
