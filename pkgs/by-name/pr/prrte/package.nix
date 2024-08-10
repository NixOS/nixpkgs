{
  lib,
  stdenv,
  removeReferencesTo,
  fetchFromGitHub,
  autoconf,
  automake,
  libtool,
  gitMinimal,
  perl,
  python3,
  flex,
  hwloc,
  libevent,
  zlib,
  pmix,
}:

stdenv.mkDerivation rec {
  pname = "prrte";
  version = "3.0.6";

  src = fetchFromGitHub {
    owner = "openpmix";
    repo = "prrte";
    rev = "v${version}";
    sha256 = "sha256-0JHtUpGFdPKmgUk0+MNxTfZIUDz/vY/CV+Mqbmv0JFw=";
    fetchSubmodules = true;
  };

  outputs = [
    "out"
    "dev"
  ];

  postPatch = ''
    patchShebangs ./autogen.pl ./config
  '';

  preConfigure = ''
    ./autogen.pl
  '';

  postInstall = ''
    moveToOutput "bin/prte_info" "''${!outputDev}"
    # Fix a broken symlink, created due to FHS assumptions
    rm "$out/bin/pcc"
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
  ];

  buildInputs = [
    libevent
    hwloc
    zlib
    pmix
  ];

  enableParallelBuilding = true;

  meta = {
    description = "PMIx Reference Runtime Environment";
    homepage = "https://docs.prrte.org/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ markuskowa ];
    platforms = lib.platforms.linux;
  };
}
