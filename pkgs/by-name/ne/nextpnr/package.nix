{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  boost,
  pypy3,
  python3,
  eigen,
  python3Packages,
  icestorm,
  trellis,
  llvmPackages,

  enableGui ? false,
  wrapQtAppsHook ? null,
  qtbase ? null,
  OpenGL ? null,
  # PyPy yields large improvements in build time and runtime performance, and
  # IceStorm isn't intended to be used as a library other than by the nextpnr
  # build process (which is also sped up by using PyPy), so we use it by default.
  # See 18839e1 for more details.
  #
  # FIXME(aseipp, 3/1/2021): pypy seems a bit busted since stdenv upgrade to gcc
  # 10/binutils 2.34, so short-circuit this for now in passthru below (done so
  # that downstream overrides can't re-enable pypy and break their build somehow)
  usePyPy ? stdenv.hostPlatform.system == "x86_64-linux",
}:

let
  boostPython = boost.override {
    python = python3;
    enablePython = true;
  };

  pname = "nextpnr";
  version = "0.7";

  passthru = rec {
    pythonPkg = if (false && usePyPy) then pypy3 else python3;
    pythonInterp = pythonPkg.interpreter;
  };

  main_src = fetchFromGitHub {
    owner = "YosysHQ";
    repo = "nextpnr";
    rev = "${pname}-${version}";
    hash = "sha256-lSY9Zn2CzEyTMU3D0Hv2jnScEtdY5wOEwGTS+pjGcGk=";
    name = "nextpnr";
    fetchSubmodules = true;
  };

  test_src = fetchFromGitHub {
    owner = "YosysHQ";
    repo = "nextpnr-tests";
    rev = "00c55a9eb9ea2e062b51fe0d64741412b185d95d";
    hash = "sha256-83suMftMtnaRFq3T2/I7Uahb11WZlXhwYt6Q/rqi2Yo=";
    name = "nextpnr-tests";
  };

  prjxray = fetchFromGitHub {
    owner = "f4pga";
    repo = "prjxray-db";
    rev = "0a0addedd73e7e4139d52a6d8db4258763e0f1f3";
    hash = "sha256-cU30ZtT+Olkcxzf/vopCT2d4IBG5vU9K3hHIvvy466c=";
    name = "prjxray-db";
  };
in

stdenv.mkDerivation rec {
  inherit pname version;

  srcs = [
    main_src
    test_src
  ];

  sourceRoot = main_src.name;

  patches = [
    (fetchpatch {
      name = "boost-1_85-fixes.patch";
      url = "https://github.com/YosysHQ/nextpnr/commit/f085950383155a745cf2e3c0f28c468d01ff5fd7.patch";
      hash = "sha256-ihN3S4eeBQSrKbHrGinE/SlIY3QDytYCaO9Mtu36n6c=";
    })
  ];

  nativeBuildInputs = [
    cmake
    python3
  ] ++ (lib.optional enableGui wrapQtAppsHook);
  buildInputs =
    [
      passthru.pythonPkg
      boostPython
      eigen
      python3Packages.apycula
    ]
    ++ (lib.optional enableGui qtbase)
    ++ (lib.optional stdenv.cc.isClang llvmPackages.openmp);

  hash = "sha256-M6LMaqPli71YvJS/4iwvowCyVaf+qe8WSICR3CgdU34=";

  cmakeFlags =
    let
      # the specified version must always start with "nextpnr-", so add it if
      # missing (e.g. if the user overrides with a git hash)
      rev = main_src.rev;
      version = if (lib.hasPrefix "nextpnr-" rev) then rev else "nextpnr-${rev}";
    in
    [
      "-DCURRENT_GIT_VERSION=${version}"
      "-DARCH=generic;ice40;ecp5;gowin;himbaechel"
      "-DBUILD_TESTS=ON"
      "-DICESTORM_INSTALL_PREFIX=${icestorm}"
      "-DTRELLIS_INSTALL_PREFIX=${trellis}"
      "-DTRELLIS_LIBDIR=${trellis}/lib/trellis"
      "-DGOWIN_BBA_EXECUTABLE=${python3Packages.apycula}/bin/gowin_bba"
      "-DUSE_OPENMP=ON"
      # warning: high RAM usage
      "-DSERIALIZE_CHIPDBS=OFF"
      "-DHIMBAECHEL_GOWIN_DEVICES=all"

      # prjxray
      "-DHIMBAECHEL_XILINX_DEVICES=xc7a50t;xc7a100t;xc7a200t"
      "-DHIMBAECHEL_PRJXRAY_DB=${prjxray}"
    ]
    ++ (lib.optional enableGui "-DBUILD_GUI=ON")
    ++ (lib.optional (
      enableGui && stdenv.hostPlatform.isDarwin
    ) "-DOPENGL_INCLUDE_DIR=${OpenGL}/Library/Frameworks");


  postPatch = ''
    # use PyPy for icestorm if enabled
    substituteInPlace ./ice40/CMakeLists.txt \
      --replace ''\'''${PYTHON_EXECUTABLE}' '${icestorm.pythonInterp}'
    substituteInPlace ./himbaechel/uarch/xilinx/CMakeLists.txt \
      --replace 'pypy3' ${passthru.pythonInterp}
  '';

  preBuild = ''
    ln -s ../${test_src.name} tests
  '';

  doCheck = true;

  postFixup = lib.optionalString enableGui ''
    wrapQtApp $out/bin/nextpnr-generic
    wrapQtApp $out/bin/nextpnr-ice40
    wrapQtApp $out/bin/nextpnr-ecp5
    wrapQtApp $out/bin/nextpnr-gowin
    wrapQtApp $out/bin/nextpnr-himbaechel
  '';

  strictDeps = true;

  meta = with lib; {
    description = "Place and route tool for FPGAs";
    homepage = "https://github.com/yosyshq/nextpnr";
    license = licenses.isc;
    platforms = platforms.all;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
