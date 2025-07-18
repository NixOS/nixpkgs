{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  boost,
  eigen,
  libxml2,
  mpi,
  python3,
  petsc,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "precice";
  version = "3.1.2";

  src = fetchFromGitHub {
    owner = "precice";
    repo = "precice";
    rev = "v${version}";
    hash = "sha256-KpmcQj8cv5V5OXCMhe2KLTsqUzKWtTeQyP+zg+Y+yd0=";
  };

  patches = lib.optionals (!lib.versionOlder "3.1.2" version) [
    (fetchpatch {
      name = "boost-187-fixes.patch";
      url = "https://github.com/precice/precice/commit/23788e9eeac49a2069e129a0cb1ac846e8cbeb9f.patch";
      hash = "sha256-Z8qOGOkXoCui8Wy0H/OeE+NaTDvyRuPm2A+VJKtjH4s=";
    })
  ];

  cmakeFlags = [
    (lib.cmakeBool "PRECICE_PETScMapping" false)
    (lib.cmakeBool "BUILD_SHARED_LIBS" true)
    (lib.cmakeFeature "PYTHON_LIBRARIES" python3.libPrefix)
    (lib.cmakeFeature "PYTHON_INCLUDE_DIR" "${python3}/include/${python3.libPrefix}")
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    python3
    python3.pkgs.numpy
  ];

  buildInputs = [
    boost
    eigen
    libxml2
    mpi
    petsc
  ];

  meta = {
    description = "preCICE stands for Precise Code Interaction Coupling Environment";
    homepage = "https://precice.org/";
    license = with lib.licenses; [ gpl3 ];
    maintainers = with lib.maintainers; [ Scriptkiddi ];
    mainProgram = "binprecice";
    platforms = lib.platforms.unix;
  };
}
