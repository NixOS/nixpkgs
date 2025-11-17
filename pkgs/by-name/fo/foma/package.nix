{
  lib,
  stdenv,
  fetchFromGitHub,
  bison,
  cmake,
  flex,
  pkg-config,
  readline,
  zlib,
}:
stdenv.mkDerivation rec {
  pname = "foma";
  version = "0.10.0alpha-unstable-2025-09-10";

  src = fetchFromGitHub {
    owner = "mhulden";
    repo = "foma";
    rev = "91f91866af843aec487313d028dbd1f76b5fb1a5";
    hash = "sha256-CXRZNcEgsjD/9PowNynPyfLVbk8KDe3T52UetYMwC6w=";
  };

  sourceRoot = "${src.name}/foma";

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    bison
    cmake
    flex
    pkg-config
  ];
  buildInputs = [
    readline
    zlib
  ];

  cmakeFlags = [
    # the cmake package does not handle absolute CMAKE_INSTALL_XXXDIR
    # correctly (setting it to an absolute path causes include files to go to
    # $out/$out/include, because the absolute path is interpreted with root at
    # $out).
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DCMAKE_INSTALL_LIBDIR=lib"
  ];

  meta = with lib; {
    description = "Multi-purpose finite-state toolkit designed for applications ranging from natural language processing to research in automata theory";
    homepage = "https://github.com/mhulden/foma";
    license = licenses.asl20;
    maintainers = [ maintainers.tckmn ];
    platforms = platforms.all;
  };
}
