{ lib
, stdenv
, fetchFromGitHub
, cmake
, help2man
, gzip
# There is a f3d overriden with EGL enabled vtk in top-level/all-packages.nix
# compiling with EGL enabled vtk will result in f3d running in headless mode
# See https://github.com/NixOS/nixpkgs/pull/324022. This may change later.
, vtk_9
, autoPatchelfHook
, Cocoa
, OpenGL
, python3Packages
, opencascade-occt
, assimp
, fontconfig
, withManual ? !stdenv.hostPlatform.isDarwin
, withPythonBinding ? false
}:

stdenv.mkDerivation rec {
  pname = "f3d";
  version = "2.5.0";

  outputs = [ "out" ] ++ lib.optionals withManual [ "man" ];

  src = fetchFromGitHub {
    owner = "f3d-app";
    repo = "f3d";
    rev = "refs/tags/v${version}";
    hash = "sha256-Mw40JyXZj+Q4a9dD5UnkUSdUfQGaV92gor8ynn86VJ8=";
  };

  nativeBuildInputs = [
    cmake
  ] ++ lib.optionals withManual [
    # manpage
    help2man
    gzip
  ] ++ lib.optionals stdenv.hostPlatform.isElf [
    # https://github.com/f3d-app/f3d/pull/1217
    autoPatchelfHook
  ];

  buildInputs = [
    vtk_9
    opencascade-occt
    assimp
    fontconfig
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    Cocoa
    OpenGL
  ] ++ lib.optionals withPythonBinding [
    python3Packages.python
    # Using C++ header files, not Python import
    python3Packages.pybind11
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
  ] ++ lib.optionals withManual [
    "-DF3D_LINUX_GENERATE_MAN=ON"
  ] ++ lib.optionals withPythonBinding [
    "-DF3D_BINDINGS_PYTHON=ON"
  ];

  meta = with lib; {
    description = "Fast and minimalist 3D viewer using VTK";
    homepage = "https://f3d-app.github.io/f3d";
    changelog = "https://github.com/f3d-app/f3d/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bcdarwin pbsds ];
    platforms = with platforms; unix;
    mainProgram = "f3d";
  };
}
