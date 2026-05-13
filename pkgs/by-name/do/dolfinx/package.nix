{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  pkg-config,
  spdlog,
  pugixml,
  boost,
  petsc,
  slepc,
  kahip,
  adios2,
  python3Packages,
  catch2_3,
  withParmetis ? false,
}:
let
  dolfinxPackages = petsc.petscPackages.overrideScope (
    final: prev: {
      slepc = final.callPackage slepc.override { };
      adios2 = final.callPackage adios2.override { };
      kahip = final.callPackage kahip.override { };
    }
  );
in
stdenv.mkDerivation (finalAttrs: {
  version = "0.10.0.post5";
  pname = "dolfinx";

  src = fetchFromGitHub {
    owner = "fenics";
    repo = "dolfinx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CK7YEtJtrx/Mto72RHT4Qjg5StO28Et+FeCYxk5T+8s=";
  };

  patches = [
    # Fix wrong span extent in _lift_bc_interior_facets
    # https://github.com/FEniCS/dolfinx/pull/4102
    (fetchpatch {
      url = "https://github.com/FEniCS/dolfinx/commit/6daca34a075a6dcdfdf77feb13d55d5dbd20e4dd.patch";
      hash = "sha256-b/C1MqslS2OBCt+kK/+vJjW8pmsJx2FQ36qDtFA1ewI=";
      includes = [ "cpp/dolfinx/fem/assemble_vector_impl.h" ];
    })
    # Fix hdf5 interface for rank 1
    # https://github.com/FEniCS/dolfinx/pull/4043
    (fetchpatch {
      url = "https://github.com/FEniCS/dolfinx/commit/fce7c44f220d4cb94c5149ad28cd1ab00909c319.patch";
      hash = "sha256-EVm4Rx5UO/3pKIVvjgYAkN+i5QR+u0Nxwxotlf41t+Q=";
    })
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    dolfinxPackages.kahip
    dolfinxPackages.scotch
  ]
  ++ lib.optional withParmetis dolfinxPackages.parmetis;

  propagatedBuildInputs = [
    spdlog
    pugixml
    boost
    petsc
    dolfinxPackages.hdf5
    dolfinxPackages.slepc
    dolfinxPackages.adios2
    python3Packages.fenics-basix
    python3Packages.fenics-ffcx
  ];

  cmakeDir = "../cpp";

  cmakeFlags = [
    (lib.cmakeBool "DOLFINX_ENABLE_ADIOS2" true)
    (lib.cmakeBool "DOLFINX_ENABLE_PETSC" true)
    (lib.cmakeBool "DOLFIN_ENABLE_PARMETIS" withParmetis)
    (lib.cmakeBool "DOLFINX_ENABLE_SCOTCH" true)
    (lib.cmakeBool "DOLFINX_ENABLE_SLEPC" true)
    (lib.cmakeBool "DOLFINX_ENABLE_KAHIP" true)
    (lib.cmakeFeature "CMAKE_INSTALL_BINDIR" "bin")
    (lib.cmakeFeature "CMAKE_INSTALL_LIBDIR" "lib")
    (lib.cmakeFeature "CMAKE_INSTALL_INCLUDEDIR" "include")
  ];

  passthru.tests = {
    unittests = stdenv.mkDerivation {
      pname = "${finalAttrs.pname}-unittests";
      inherit (finalAttrs) version src;

      cmakeDir = "../cpp/test";

      nativeBuildInputs = [
        cmake
        pkg-config
      ];

      buildInputs = [ finalAttrs.finalPackage ];

      nativeCheckInputs = [ catch2_3 ];

      doCheck = true;

      installPhase = ''
        touch $out
      '';
    };
  };

  meta = {
    homepage = "https://fenicsproject.org";
    downloadPage = "https://github.com/fenics/dolfinx";
    description = "Computational environment of FEniCSx and implements the FEniCS Problem Solving Environment in C++ and Python";
    changelog = "https://github.com/fenics/dolfinx/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [
      bsd2
      lgpl3Plus
    ];
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ qbisi ];
  };
})
