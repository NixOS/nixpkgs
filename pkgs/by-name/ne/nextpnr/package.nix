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
  version = "0.9";

  prjbeyond_src = fetchFromGitHub {
    owner = "YosysHQ-GmbH";
    repo = "prjbeyond-db";
    rev = "f49f66be674d9857c657930353b867ba94bcbdd7";
    hash = "sha256-B/VmKgMu6f2Y8umE+NgGD5W0FYBIfDcMVwgHocFzreA=";
  };
in

stdenv.mkDerivation rec {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "YosysHQ";
    repo = "nextpnr";
    tag = "${pname}-${version}";
    hash = "sha256-rpg99k7rSNU4p5D0iXipLgNNOA2j0PdDsz8JTxyYNPM=";
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

      # gatemate excluded due to non-reproducible build https://github.com/YosysHQ/prjpeppercorn/issues/9
      # xilinx excluded due to needing vivado https://github.com/f4pga/prjxray?tab=readme-ov-file#step-1
      "-DHIMBAECHEL_UARCH=example;gowin;ng-ultra"

      "-DHIMBAECHEL_GOWIN_DEVICES=all"
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
