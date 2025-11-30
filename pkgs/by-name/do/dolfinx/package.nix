{
  lib,
  stdenv,
  fetchFromGitHub,
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
  darwinMinVersionHook,
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
  version = "0.10.0.post3";
  pname = "dolfinx";

  src = fetchFromGitHub {
    owner = "fenics";
    repo = "dolfinx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YsFya92lz9Twc1PsSLGj6tJNvKb+MQfpmN/qOFxbe34=";
  };

  preConfigure = ''
    cd cpp
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    dolfinxPackages.kahip
    dolfinxPackages.scotch
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin (darwinMinVersionHook "13.3")
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

      preConfigure = ''
        cd cpp/test
      '';

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
