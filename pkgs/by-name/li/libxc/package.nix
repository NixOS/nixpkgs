{
  lib,
  stdenv,
  fetchFromGitLab,
  fetchpatch,
  cmake,
  gfortran,
  perl,
  version ? "6.2.2",
}:

let
  versionHashes = {
    "6.2.2" = "sha256-JYhuyW95I7Q0edLIe7H//+ej5vh6MdAGxXjmNxDMuhQ=";
    "7.0.0" = "sha256-mGyGtKDurOrSS0AYrtwhF62pJGPBLbPPNBgFV7fyyug=";
  };

in
stdenv.mkDerivation rec {
  pname = "libxc";
  inherit version;

  src = fetchFromGitLab {
    owner = "libxc";
    repo = "libxc";
    rev = version;
    hash = versionHashes."${version}";
  };

  patches = [
    # Fix build with newer CMake versions
    (fetchpatch {
      url = "https://gitlab.com/libxc/libxc/-/commit/450202adb8a3d698841dca853f2999b1befd932e.patch";
      sha256 = "sha256-XDt7+TzszSu+X6/PS+T8Q9BP76+bAXC9FzkA6ueo/OA=";
    })
  ];

  # Timeout increase has already been included upstream in master.
  # Check upon updates if this can be removed.
  postPatch = ''
    substituteInPlace testsuite/CMakeLists.txt \
        --replace "PROPERTIES TIMEOUT 1" "PROPERTIES TIMEOUT 30"
  '';

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    perl
    cmake
    gfortran
  ];

  preConfigure = ''
    patchShebangs ./
  '';

  cmakeFlags = [
    "-DENABLE_FORTRAN=ON"
    "-DBUILD_SHARED_LIBS=ON"
    "-DENABLE_XHOST=OFF"
    # Force compilation of higher derivatives
    "-DDISABLE_VXC=0"
    "-DDISABLE_FXC=0"
    "-DDISABLE_KXC=0"
    "-DDISABLE_LXC=0"
  ];

  doCheck = true;

  meta = {
    description = "Library of exchange-correlation functionals for density-functional theory";
    mainProgram = "xc-info";
    homepage = "https://www.tddft.org/programs/Libxc/";
    license = lib.licenses.mpl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ markuskowa ];
  };
}
