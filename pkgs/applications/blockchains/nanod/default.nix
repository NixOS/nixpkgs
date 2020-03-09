{ lib, stdenv, fetchFromGitHub, cmake, pkgconfig, boost, darwin, ocl-icd, opencl-headers, Foundation, OpenCL}:

stdenv.mkDerivation rec {

  pname = "nanod";
  version = "20.0";

  src = fetchFromGitHub {
    owner = "nanocurrency";
    repo = "nano-node";
    rev = "V${version}";
    sha256 = "12nrjjd89yjzx20d85ccmp395pl0djpx0x0qb8dgka8xfy11k7xn";
    fetchSubmodules = true;
  };

  # Use a patch to force dynamic linking
  patches = [
    ./CMakeLists.txt.patch
  ];

  cmakeFlags = let
    options = {
      BOOST_ROOT = boost;
      Boost_USE_STATIC_LIBS = "OFF";
    };
    optionToFlag = name: value: "-D${name}=${value}";
  in lib.mapAttrsToList optionToFlag options;

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ boost ]
                ++ stdenv.lib.optionals (!stdenv.isDarwin) [ ocl-icd opencl-headers ]
                ++ stdenv.lib.optionals stdenv.isDarwin [ Foundation OpenCL ];

  buildPhase = ''
    make nano_node
  '';

  # Move executables under bin directory
  postInstall = ''
    mkdir -p $out/bin
    mv nano_node $out/bin/nanod
  '';

  meta = {
    inherit version;
    description = "Nano is a digital payment protocol designed to be accessible and lightweight";
    longDescription = "This package includes the Nano node software (nanod) that enables a machine to participate as a node on the live Nano network.";
    homepage = https://nano.org;
    license = lib.licenses.bsd2;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ qasaur ];
  };

}
