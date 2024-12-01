{ stdenv
, lib
, fetchFromGitHub
, fetchpatch2
, gfortran
, meson
, ninja
, pkg-config
, python3
, blas
, lapack
, mctc-lib
, mstore
}:

assert !blas.isILP64 && !lapack.isILP64;

stdenv.mkDerivation rec {
  pname = "multicharge";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "grimme-lab";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-oUI5x5/Gd0EZBb1w+0jlJUF9X51FnkHFu8H7KctqXl0=";
  };

  patches = [
    # Fix finding of MKL for Intel 2021 and newer
    # Also fix finding mstore
    # https://github.com/grimme-lab/multicharge/pull/20
    (fetchpatch2 {
      url = "https://github.com/grimme-lab/multicharge/commit/98a11ac524cd2a1bd9e2aeb8f4429adb2d76ee8.patch";
      hash = "sha256-zZ2pcbyaHjN2ZxpMhlqUtIXImrVsLk/8WIcb9IYPgBw=";
    })
  ];

  nativeBuildInputs = [ gfortran meson ninja pkg-config python3 ];

  buildInputs = [ blas lapack mctc-lib mstore ];

  outputs = [ "out" "dev" ];

  doCheck = true;

  postPatch = ''
    patchShebangs --build config/install-mod.py
  '';

  preCheck = ''
    export OMP_NUM_THREADS=2
  '';

  meta = with lib; {
    description = "Electronegativity equilibration model for atomic partial charges";
    mainProgram = "multicharge";
    license = licenses.asl20;
    homepage = "https://github.com/grimme-lab/multicharge";
    platforms = platforms.linux;
    maintainers = [ maintainers.sheepforce ];
  };
}
