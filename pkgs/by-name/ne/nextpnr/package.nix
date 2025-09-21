{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  boost,
  python3,
  eigen,
  python3Packages,
  icestorm,
  trellis,
  llvmPackages,

  enableGui ? false,
  wrapQtAppsHook ? null,
  qtbase ? null,
}:

let
  boostPython = boost.override {
    python = python3;
    enablePython = true;
  };

  pname = "nextpnr";
  version = "0.8";

  prjxray_src = fetchFromGitHub {
    owner = "f4pga";
    repo = "prjxray";
    rev = "faf9c774a340e39cf6802d009996ed6016e63521";
    hash = "sha256-BEv7vJoOHWHZoc9EXbesfwFFClkuiSpVwHUrj4ahUcA=";
  };

  prjbeyond_src = fetchFromGitHub {
    owner = "YosysHQ-GmbH";
    repo = "prjbeyond-db";
    rev = "06d3b424dd0e52d678087c891c022544238fb9e3";
    hash = "sha256-nmyFFUO+/J2lb+lPATEjdYq0d21P1fN3N94JXR8brZ0=";
  };
in

stdenv.mkDerivation rec {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "YosysHQ";
    repo = "nextpnr";
    tag = "${pname}-${version}";
    hash = "sha256-lconcmLACxWxC41fTIkUaGbfp79G98YdHA4mRJ9Qo1w=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    python3
  ]
  ++ (lib.optional enableGui wrapQtAppsHook);
  buildInputs = [
    boostPython
    eigen
    python3Packages.apycula
  ]
  ++ (lib.optional enableGui qtbase)
  ++ (lib.optional stdenv.cc.isClang llvmPackages.openmp);

  cmakeFlags =
    let
      # the specified version must always start with "nextpnr-", so add it if
      # missing (e.g. if the user overrides with a git hash)
      rev = src.rev;
      version = if (lib.hasPrefix "nextpnr-" rev) then rev else "nextpnr-${rev}";
    in
    [
      "-DCURRENT_GIT_VERSION=${version}"
      "-DARCH=generic;ice40;ecp5;himbaechel"
      "-DBUILD_TESTS=ON"
      "-DICESTORM_INSTALL_PREFIX=${icestorm}"
      "-DTRELLIS_INSTALL_PREFIX=${trellis}"
      "-DTRELLIS_LIBDIR=${trellis}/lib/trellis"
      "-DGOWIN_BBA_EXECUTABLE=${python3Packages.apycula}/bin/gowin_bba"
      "-DUSE_OPENMP=ON"
      "-DHIMBAECHEL_UARCH=all"
      "-DHIMBAECHEL_GOWIN_DEVICES=all"
      "-DHIMBAECHEL_PRJXRAY_DB=${prjxray_src}"
      "-DHIMBAECHEL_PRJBEYOND_DB=${prjbeyond_src}"
    ]
    ++ (lib.optional enableGui "-DBUILD_GUI=ON");

  postPatch = ''
    # Don't use #embed macro for chipdb binary embeddings - otherwise getting spurious type narrowing errors.
    # Maybe related to: https://github.com/llvm/llvm-project/issues/119256
    substituteInPlace CMakeLists.txt \
      --replace-fail "check_cxx_compiler_hash_embed(HAS_HASH_EMBED CXX_FLAGS_HASH_EMBED)" ""
  '';

  doCheck = true;

  postFixup = lib.optionalString enableGui ''
    wrapQtApp $out/bin/nextpnr-generic
    wrapQtApp $out/bin/nextpnr-ice40
    wrapQtApp $out/bin/nextpnr-ecp5
    wrapQtApp $out/bin/nextpnr-himbaechel
  '';

  strictDeps = true;

  meta = {
    description = "Place and route tool for FPGAs";
    homepage = "https://github.com/yosyshq/nextpnr";
    license = lib.licenses.isc;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ thoughtpolice ];
  };
}
