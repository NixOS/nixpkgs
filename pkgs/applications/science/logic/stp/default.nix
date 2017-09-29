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

  meta = with stdenv.lib; {
    description = "Simple Theorem Prover";
    maintainers = with maintainers; [ mornfall ];
    platforms = platforms.linux;
    license = licenses.mit;
  };
}
