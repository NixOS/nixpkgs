{ stdenv, cmake, boost, bison, flex, fetchFromGitHub, perl, python3, python3Packages, zlib, minisatUnstable, cryptominisat }:

stdenv.mkDerivation rec {
  version = "2.2.0";
  name = "stp-${version}";

  src = fetchFromGitHub {
    owner = "stp";
    repo = "stp";
    rev    = "stp-${version}";
    sha256 = "1jh23wjm62nnqfx447g2y53bbangq04hjrvqc35v9xxpcjgj3i49";
  };

  buildInputs = [ boost zlib minisatUnstable cryptominisat python3 ];
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

  # `make -f lib/Interface/CMakeFiles/cppinterface.dir/build.make lib/Interface/CMakeFiles/cppinterface.dir/cpp_interface.cpp.o`:
  # include/stp/AST/UsefulDefs.h:41:29: fatal error: stp/AST/ASTKind.h: No such file or directory
  enableParallelBuilding = false;

  meta = with stdenv.lib; {
    description = "Simple Theorem Prover";
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
    license = licenses.mit;
  };
}
