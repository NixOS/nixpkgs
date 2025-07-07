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
  tbb,
  # There is a f3d overridden with EGL enabled vtk in top-level/all-packages.nix
  # compiling with EGL enabled vtk will result in f3d running in headless mode
  # See https://github.com/NixOS/nixpkgs/pull/324022. This may change later.
  vtk_9,
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
  version = "3.1.0";

  outputs = [ "out" ] ++ lib.optionals withManual [ "man" ];

  src = fetchFromGitHub {
    owner = "f3d-app";
    repo = "f3d";
    tag = "v${version}";
    hash = "sha256-QJQlZXUZyWhpYteHoIsGOj1jdf3Lpy/BMXopeto4IRo=";
  };

  patches = [
    # https://github.com/f3d-app/f3d/pull/2155
    (fetchpatch {
      name = "add-missing-include.patch";
      url = "https://github.com/f3d-app/f3d/commit/3814f3356d888ce59bbe6eda0293c2de73b0c89a.patch";
      hash = "sha256-TeV8byIxX6PBEW06/sS7kHaSS99S88WiyzjHZ/Zh5x4=";
    })

    # https://github.com/f3d-app/f3d/pull/2286
    (fetchpatch {
      name = "fix_assimp_6_0_configuration.patch";
      url = "https://github.com/f3d-app/f3d/commit/9bed68ef2b5425c9600c81a7245f13ed2d4079b8.patch";
      hash = "sha256-u4VQiTTgFSYxdJ3wvQUfSTt2fcsXBO3p15f/cNRRCHo=";
    })
  ];

  nativeBuildInputs =
    [
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

  buildInputs =
    [
      vtk_9
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
      tbb
    ];

  cmakeFlags =
    [
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
