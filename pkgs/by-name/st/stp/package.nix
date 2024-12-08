{ lib
, stdenv
, cmake
, boost
, bison
, flex
, fetchFromGitHub
, fetchpatch
, perl
, python3
, zlib
, minisat
, cryptominisat
}:

stdenv.mkDerivation rec {
  pname = "stp";
  version = "2.3.3";

  src = fetchFromGitHub {
    owner = "stp";
    repo = "stp";
    rev = version;
    hash = "sha256-B+HQF4TJPkYrpodE4qo4JHvlu+a5HTJf1AFyXTnZ4vk=";
  };
  patches = [
    # Fix missing type declaration
    # due to undeterminisitic compilation
    # of circularly dependent headers
    ./stdint.patch

    # Python 3.12+ compatibility for build: https://github.com/stp/stp/pull/450
    (fetchpatch {
      url = "https://github.com/stp/stp/commit/fb185479e760b6ff163512cb6c30ac9561aadc0e.patch";
      hash = "sha256-guFgeWOrxRrxkU7kMvd5+nmML0rwLYW196m1usE2qiA=";
    })
  ];

  postPatch = ''
    # Upstream fix for gcc-13 support:
    #   https://github.com/stp/stp/pull/462
    # Can't apply it as is as patch context changed in ither patches.
    # TODO: remove me on 2.4 release
    sed -e '1i #include <cstdint>' -i include/stp/AST/ASTNode.h
  '';

  buildInputs = [
    boost
    zlib
    minisat
    cryptominisat
    python3
  ];
  nativeBuildInputs = [ cmake bison flex perl ];
  preConfigure = ''
    python_install_dir=$out/${python3.sitePackages}
    mkdir -p $python_install_dir
    cmakeFlagsArray=(
      $cmakeFlagsArray
      "-DBUILD_SHARED_LIBS=ON"
      "-DPYTHON_LIB_INSTALL_DIR=$python_install_dir"
    )
  '';

  meta = with lib; {
    description = "Simple Theorem Prover";
    maintainers = with maintainers; [ McSinyx numinit ];
    platforms = platforms.linux;
    license = licenses.mit;
  };
}
