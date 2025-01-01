{ lib, stdenv, fetchFromGitHub, cmake
, boost, python3, eigen, python3Packages
, icestorm, trellis
, llvmPackages

, enableGui ? false
, wrapQtAppsHook ? null
, qtbase ? null
, OpenGL ? null
}:

let
  boostPython = boost.override { python = python3; enablePython = true; };

  pname = "nextpnr";
  version = "0.7";

  main_src = fetchFromGitHub {
    owner = "YosysHQ";
    repo  = "nextpnr";
    rev   = "${pname}-${version}";
    hash  = "sha256-YIAQcCg9RjvCys1bQ3x+sTgTmnmEeXVbt9Lr6wtg1pA=";
    name  = "nextpnr";
  };

  test_src = fetchFromGitHub {
    owner  = "YosysHQ";
    repo   = "nextpnr-tests";
    rev    = "00c55a9eb9ea2e062b51fe0d64741412b185d95d";
    hash = "sha256-83suMftMtnaRFq3T2/I7Uahb11WZlXhwYt6Q/rqi2Yo=";
    name   = "nextpnr-tests";
  };
in

stdenv.mkDerivation rec {
  inherit pname version;

  srcs = [ main_src test_src ];

  sourceRoot = main_src.name;

  nativeBuildInputs
     = [ cmake python3 ]
    ++ (lib.optional enableGui wrapQtAppsHook);
  buildInputs
     = [ boostPython eigen python3Packages.apycula ]
    ++ (lib.optional enableGui qtbase)
    ++ (lib.optional stdenv.cc.isClang llvmPackages.openmp);

  cmakeFlags =
    [ "-DCURRENT_GIT_VERSION=${lib.substring 0 7 (lib.elemAt srcs 0).rev}"
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
    ]
    ++ (lib.optional enableGui "-DBUILD_GUI=ON")
    ++ (lib.optional (enableGui && stdenv.hostPlatform.isDarwin)
        "-DOPENGL_INCLUDE_DIR=${OpenGL}/Library/Frameworks");

  patchPhase = with builtins; ''
    # use PyPy for icestorm if enabled
    substituteInPlace ./ice40/CMakeLists.txt \
      --replace ''\'''${PYTHON_EXECUTABLE}' '${icestorm.pythonInterp}'
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
    homepage    = "https://github.com/yosyshq/nextpnr";
    license     = licenses.isc;
    platforms   = platforms.all;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
