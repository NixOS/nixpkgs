{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  sfml,
  libX11,
  glew,
  python3,
  glm,
  meshoptimizer,
  SDL2,
  ninja,
}:

let
  version = {
    seriousproton = "2024.06.20";
    emptyepsilon = "2024.06.20";
    basis-universal = "v1_15_update2";
  };

  basis-universal = fetchFromGitHub {
    owner = "BinomialLLC";
    repo = "basis_universal";
    rev = version.basis-universal;
    hash = "sha256-2snzq/SnhWHIgSbUUgh24B6tka7EfkGO+nwKEObRkU4=";
  };

  serious-proton = stdenv.mkDerivation {
    pname = "serious-proton";
    version = version.seriousproton;

    src = fetchFromGitHub {
      owner = "daid";
      repo = "SeriousProton";
      rev = "EE-${version.seriousproton}";
      hash = "sha256-byLk4ukpj+s74+3K+1wzRTXhe4pKkH0pOSYeVs94muc=";
    };

    nativeBuildInputs = [ cmake ];
    buildInputs = [
      sfml
      libX11
      glm
      SDL2
    ];

    cmakeFlags = [
      (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_BASIS" "${basis-universal}")
      (lib.cmakeFeature "CMAKE_CXX_FLAGS" "-DGLM_ENABLE_EXPERIMENTAL")
    ];

    meta = with lib; {
      description = "C++ game engine coded on top of SFML used for EmptyEpsilon";
      homepage = "https://github.com/daid/SeriousProton";
      license = licenses.mit;
      maintainers = with maintainers; [ fpletz ];
      platforms = platforms.linux;
    };
  };

in

stdenv.mkDerivation {
  pname = "empty-epsilon";
  version = version.emptyepsilon;

  src = fetchFromGitHub {
    owner = "daid";
    repo = "EmptyEpsilon";
    rev = "EE-${version.emptyepsilon}";
    hash = "sha256-YTZliu1o3LFab43DqmSk/cifxRWZMPxdV4gNoNy8LEk=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    serious-proton
    sfml
    glew
    libX11
    python3
    glm
    SDL2
    ninja
  ];

  cmakeFlags = [
    (lib.cmakeFeature "SERIOUS_PROTON_DIR" "${serious-proton.src}")
    (lib.cmakeFeature "CPACK_PACKAGE_VERSION" "${version.emptyepsilon}")
    (lib.cmakeFeature "CPACK_PACKAGE_VERSION_MAJOR" "${lib.versions.major version.emptyepsilon}")
    (lib.cmakeFeature "CPACK_PACKAGE_VERSION_MINOR" "${lib.versions.minor version.emptyepsilon}")
    (lib.cmakeFeature "CPACK_PACKAGE_VERSION_PATCH" "${lib.versions.patch version.emptyepsilon}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_BASIS" "${basis-universal}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_MESHOPTIMIZER" "${meshoptimizer.src}")
    (lib.cmakeFeature "CMAKE_AR" "${stdenv.cc.cc}/bin/gcc-ar")
    (lib.cmakeFeature "CMAKE_RANLIB" "${stdenv.cc.cc}/bin/gcc-ranlib")
    (lib.cmakeFeature "CMAKE_CXX_FLAGS" "-DGLM_ENABLE_EXPERIMENTAL")
    "-G Ninja"
  ];

  meta = with lib; {
    description = "Open source bridge simulator based on Artemis";
    mainProgram = "EmptyEpsilon";
    homepage = "https://daid.github.io/EmptyEpsilon/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [
      fpletz
      ma27
    ];
    platforms = platforms.linux;
  };
}
