{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  help2man,
  gzip,
  libXt,
  openusd,
  onetbb,
  vtk,
  autoPatchelfHook,
  python3Packages,
  opencascade-occt,
  assimp,
  fontconfig,
  withManual ? !stdenv.hostPlatform.isDarwin,
  withPythonBinding ? false,
  withUsd ? openusd.meta.available,
}:

stdenv.mkDerivation rec {
  pname = "f3d";
  version = "3.2.0";

  outputs = [ "out" ] ++ lib.optionals withManual [ "man" ];

  src = fetchFromGitHub {
    owner = "f3d-app";
    repo = "f3d";
    tag = "v${version}";
    hash = "sha256-p1Cqam3sYDXJCU1A2sC/fV1ohxS3FGiVrxeGooNXVBQ=";
  };

  nativeBuildInputs = [
    cmake
  ]
  ++ lib.optionals withManual [
    # manpage
    help2man
    gzip
  ]
  ++ lib.optionals stdenv.hostPlatform.isElf [
    # https://github.com/f3d-app/f3d/pull/1217
    autoPatchelfHook
  ];

  buildInputs = [
    vtk
    opencascade-occt
    assimp
    fontconfig
  ]
  ++ lib.optionals withPythonBinding [
    python3Packages.python
    # Using C++ header files, not Python import
    python3Packages.pybind11
  ]
  ++ lib.optionals withUsd [
    libXt
    openusd
    onetbb
  ];

  cmakeFlags = [
    # conflict between VTK and Nixpkgs;
    # see https://github.com/NixOS/nixpkgs/issues/89167
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DCMAKE_INSTALL_BINDIR=bin"
    "-DF3D_MODULE_EXTERNAL_RENDERING=ON"
    "-DF3D_PLUGIN_BUILD_ASSIMP=ON"
    "-DF3D_PLUGIN_BUILD_OCCT=ON"
  ]
  ++ lib.optionals withManual [
    "-DF3D_LINUX_GENERATE_MAN=ON"
  ]
  ++ lib.optionals withPythonBinding [
    "-DF3D_BINDINGS_PYTHON=ON"
  ]
  ++ lib.optionals withUsd [
    "-DF3D_PLUGIN_BUILD_USD=ON"
  ];

  meta = {
    description = "Fast and minimalist 3D viewer using VTK";
    homepage = "https://f3d-app.github.io/f3d";
    changelog = "https://github.com/f3d-app/f3d/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      bcdarwin
      pbsds
    ];
    platforms = with lib.platforms; unix;
    mainProgram = "f3d";
  };
}
