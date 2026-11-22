{
  lib,
  stdenv,
  fetchFromGitLab,
  fetchpatch,
  cmake,
  gfortran,
  perl,
  python3,
  version ? "6.2.2",
}:

let
  versionHashes = {
    "6.2.2" = "sha256-JYhuyW95I7Q0edLIe7H//+ej5vh6MdAGxXjmNxDMuhQ=";
    "7.1.2" = "sha256-aziifUOOrL8lkHiZQ8pb3RaKXvXs0mm4qB5gXHlkmZo=";
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

  patches = lib.optionals (lib.versionOlder version "7.1.0") [
    # Fix build with newer CMake versions
    (fetchpatch {
      url = "https://gitlab.com/libxc/libxc/-/commit/450202adb8a3d698841dca853f2999b1befd932e.patch";
      sha256 = "sha256-XDt7+TzszSu+X6/PS+T8Q9BP76+bAXC9FzkA6ueo/OA=";
    })
  ];

  # Timeout increase has been included upstream 7.1.0.
  postPatch = lib.optionalString (lib.versionOlder version "7.1.0") ''
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
  ]
  ++ lib.optionals (lib.versionAtLeast version "7.1.0") [
    (python3.withPackages (ps: [
      ps.pytest
      ps.numpy
    ]))
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

  # Exclude python-tests: they require ENABLE_PYTHON=ON and the pylibxc module,
  # which is not built in the default configuration.
  checkPhase = ''
    runHook preCheck
    ctest --exclude-regex python-tests --output-on-failure
    runHook postCheck
  '';

  meta = {
    description = "Library of exchange-correlation functionals for density-functional theory";
    mainProgram = "xc-info";
    homepage = "https://libxc.gitlab.io";
    license = lib.licenses.mpl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ markuskowa ];
  };
}
