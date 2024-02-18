{ lib, stdenv, cmake, boost, bison, flex, fetchFromGitHub, perl
, python3, python3Packages, zlib, minisat, cryptominisat }:

stdenv.mkDerivation rec {
  pname = "stp";
  version = "2.3.3";

  src = fetchFromGitHub {
    owner = "stp";
    repo = "stp";
    rev    = version;
    sha256 = "1yg2v4wmswh1sigk47drwsxyayr472mf4i47lqmlcgn9hhbx1q87";
  };
  patches = [
    # Fix missing type declaration
    # due to undeterminisitic compilation
    # of circularly dependent headers
    ./stdint.patch
  ];

  postPatch = ''
    # Upstream fix for gcc-13 support:
    #   https://github.com/stp/stp/pull/462
    # Can't apply it as is as patch context changed in ither patches.
    # TODO: remove me on 2.4 release
    sed -e '1i #include <cstdint>' -i include/stp/AST/ASTNode.h
  '';

  buildInputs = [ boost zlib minisat cryptominisat python3 ];
  nativeBuildInputs = [ cmake bison flex perl ];
  preConfigure = ''
    python_install_dir=$out/${python3Packages.python.sitePackages}
    mkdir -p $python_install_dir
    cmakeFlagsArray=(
      $cmakeFlagsArray
      "-DBUILD_SHARED_LIBS=ON"
      "-DPYTHON_LIB_INSTALL_DIR=$python_install_dir"
    )
  '';

  meta = with lib; {
    description = "Simple Theorem Prover";
    maintainers = with maintainers; [ McSinyx ];
    platforms = platforms.linux;
    license = licenses.mit;
  };
}
