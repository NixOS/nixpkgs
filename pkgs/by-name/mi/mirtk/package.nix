{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  python3,
  boost186,
  eigen,
  libGLU,
  fltk,
  vtk,
  zlib,
  onetbb,
}:

stdenv.mkDerivation {
  pname = "mirtk";
  version = "2.0.0-unstable-2025-02-27";

  src = fetchFromGitHub {
    owner = "BioMedIA";
    repo = "MIRTK";
    rev = "ef71a176c120447b3f95291901af7af8b4f00544";
    hash = "sha256-77Om/+qApt9AiSYbaPc2QNh+RKcYajobD7VDhvPtf/I=";
    fetchSubmodules = true;
  };

  cmakeFlags = [
    "-DWITH_VTK=ON"
    "-DMODULE_Deformable=ON"
    "-DMODULE_Mapping=ON"
    "-DMODULE_Scripting=ON"
    "-DMODULE_Viewer=ON"
    "-DMODULE_DrawEM=OFF"
    "-DWITH_TBB=ON"
    "-DWITH_GIFTICLIB=ON"
    "-DWITH_NIFTILIB=ON"
  ];

  # tests don't seem to be maintained and gtest fails to link with BUILD_TESTING=ON;
  # unclear if specific to Nixpkgs
  doCheck = false;

  postPatch = ''
    # Their old `FindTBB` module conflicts with others.
    rm CMake/Modules/FindTBB.cmake
    substituteInPlace CMake/Modules/CMakeLists.txt \
      --replace-fail '"FindTBB.cmake"' ""

    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 3.4 FATAL_ERROR)" "cmake_minimum_required(VERSION 3.10)"

    substituteInPlace CMake/Basis/{BasisSettings.cmake,ProjectTools.cmake,configure_script.cmake.in} \
      --replace-fail "cmake_minimum_required (VERSION 2.8.12 FATAL_ERROR)" "cmake_minimum_required(VERSION 3.10)"

    substituteInPlace {ThirdParty/LBFGS,Packages/Deformable,Packages/Mapping,Packages/Scripting,Packages/Viewer}/CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 2.8.12 FATAL_ERROR)" "cmake_minimum_required(VERSION 3.10)"
  '';

  postInstall = ''
    install -Dm644 -t "$out/share/bash-completion/completions/mirtk" share/completion/bash/mirtk
  '';

  env.NIX_CFLAGS_COMPILE = "-Wno-changes-meaning";

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    boost186
    eigen
    fltk
    libGLU
    python3
    onetbb
    vtk
    zlib
  ];

  meta = {
    homepage = "https://github.com/BioMedIA/MIRTK";
    description = "Medical image registration library and tools";
    mainProgram = "mirtk";
    maintainers = with lib.maintainers; [ bcdarwin ];
    platforms = lib.platforms.linux;
    license = lib.licenses.asl20;
  };
}
