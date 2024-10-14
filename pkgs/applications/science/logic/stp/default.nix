{ lib
, stdenv
, cmake
, boost
, bison
, flex
, pkg-config
, fetchFromGitHub
, fetchpatch
, perl
, python3
, zlib
, minisat
, cryptominisat
, gmp
, gtest
, lit
, outputcheck
}:

stdenv.mkDerivation rec {
  pname = "stp";
  version = "2.3.4";

  src = fetchFromGitHub {
    owner = "stp";
    repo = "stp";
    rev = version;
    hash = "sha256-PtONKgqahT9x+5WHi3zyoXwDTdq/VapzBl3Aod7Cbgc=";
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

  buildInputs = [
    boost
    zlib
    minisat
    cryptominisat
    python3
    gmp
  ];
  nativeBuildInputs = [ cmake bison flex perl pkg-config gtest lit ];
  cmakeFlags = [ "-DBUILD_SHARED_LIBS=ON" "-DENABLE_TESTING=ON" "-DLIT_ARGS=-v" ];
  preConfigure = ''
    python_install_dir=$out/${python3.sitePackages}
    mkdir -p $python_install_dir
    cmakeFlagsArray=(
      $cmakeFlagsArray
      "-DPYTHON_LIB_INSTALL_DIR=$python_install_dir"
    )

    # Version is wrong in 2.3.4, fix it.
    substituteInPlace CMakeLists.txt \
      --replace-fail 2.3.3 ${version} \
      --replace-fail GIT-hash-notfound ${version}

    # We want to use the Nix wrapper for the output check tool instead of running it through Python
    substituteInPlace tests/query-files/lit.cfg \
      --replace-fail "pythonExec + ' ' +OutputCheckTool" "OutputCheckTool"

    # Link in gtest and the output check utility.
    mkdir -p deps
    ln -s ${gtest.src} deps/gtest
    ln -s ${outputcheck} deps/OutputCheck
  '';

  doCheck = true;

  postInstall = ''
    # Clean up installed gtest/gmock files that shouldn't be there.
    find $out/ \( -iname '*gtest*' -o -iname '*gmock*' \) -print | while read -r file; do
      if [ -e "$file" ]; then
        echo "Removing $file" >&2
        rm -rf "$file"
      fi
    done

    # Remove empty pkgconfig folders.
    find $out/ -type d -name pkgconfig -print | while read -r dir; do
      if [ -z "$(ls -A "$dir")" ]; then
        echo "Cleaning up empty pkgconfig directory at $dir" >&2
        rm -rf "$dir"
      fi
    done
  '';

  doInstallCheck = true;
  postInstallCheck = ''
    $out/bin/stp --version | grep '^STP version ${version}'
  '';

  meta = with lib; {
    description = "Simple Theorem Prover";
    maintainers = with maintainers; [ McSinyx numinit ];
    platforms = platforms.linux;
    license = licenses.mit;
  };
}
