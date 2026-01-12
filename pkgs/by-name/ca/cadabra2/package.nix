{
  lib,
  stdenv,
  fetchFromGitHub,

  cmake,
  pkg-config,
  makeBinaryWrapper,
  wrapGAppsHook3,
  nix-update-script,

  boost,
  glibmm,
  gmpxx,
  gtkmm3,
  jsoncpp,
  onetbb,
  openssl,
  python3,
  sqlite,

  catch2_3,
  writableTmpDirAsHomeHook,
  versionCheckHook,

  # Enable Mathematica support
  enableMathematica ? false,
  # Build cadabra as a C++ library
  enableBuildAsCppLibrary ? false,
  # Enable building the Xeus-based Jupyter kernel
  enableJupyter ? false,
  # Enable building the default Jupyter kernel
  enablePyJupyter ? true,
  # Enable the UI frontend
  enableFrontend ? true,
}:

assert lib.assertMsg (
  enableMathematica -> !stdenv.hostPlatform.isDarwin
) "Mathematica scalar backend does not yet work on macOS.";

stdenv.mkDerivation (finalAttrs: {
  pname = "cadabra2";
  version = "2.5.14";

  src = fetchFromGitHub {
    owner = "kpeeters";
    repo = "cadabra2";
    tag = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-lQ/xGxWa126EzxDIsXoi3brnECcXLXxzzUizLpRjZOg=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail 'MESSAGE(FATAL_ERROR "Building with -DPACKAGING_MODE=ON also requires -DCMAKE_INSTALL_PREFIX=/usr")' ""
  '';

  cmakeFlags = [
    (lib.cmakeFeature "PYTHON_SITE_PATH" "${placeholder "out"}/${python3.sitePackages}")

    (lib.cmakeBool "ENABLE_FRONTEND" enableFrontend)
    (lib.cmakeBool "ENABLE_JUPYTER" enableJupyter)
    (lib.cmakeBool "ENABLE_PY_JUPYTER" enablePyJupyter)
    (lib.cmakeBool "ENABLE_MATHEMATICA" enableMathematica)
    (lib.cmakeBool "BUILD_AS_CPP_LIBRARY" enableBuildAsCppLibrary)
    (lib.cmakeBool "ENABLE_SYSTEM_JSONCPP" true)
    (lib.cmakeBool "FETCHCONTENT_FULLY_DISCONNECTED" true)
    (lib.cmakeBool "PACKAGING_MODE" true)

    (lib.cmakeBool "BUILD_TESTS" finalAttrs.doCheck)
  ];

  nativeBuildInputs = [
    cmake
    makeBinaryWrapper
    pkg-config
    python3
  ]
  ++ lib.optional enableFrontend wrapGAppsHook3;

  buildInputs = [
    boost
    glibmm
    gmpxx
    jsoncpp
    onetbb
    openssl
    python3.pkgs.pybind11
    sqlite
  ]
  ++ lib.optional enableFrontend gtkmm3;

  propagatedBuildInputs = with python3.pkgs; [
    matplotlib
    mpmath
    sympy
    gmpy2
  ];

  preFixup = ''
    wrapper_args=(
      --prefix PATH : "$out/bin"
      --prefix PYTHONPATH : "$out/${python3.sitePackages}"
      --prefix PYTHONPATH : "${python3.pkgs.makePythonPath finalAttrs.propagatedBuildInputs}"
    )
    gappsWrapperArgs+=("''${wrapper_args[@]}")
  ''
  + lib.optionalString (!enableFrontend) ''
    for program in $out/bin/*; do
      wrapProgram "$program" "''${wrapper_args[@]}"
    done
  '';

  checkInputs = [ catch2_3 ];
  nativeCheckInputs = [ writableTmpDirAsHomeHook ];
  doCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = !enableBuildAsCppLibrary;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Field-theory motivated approach to computer algebra";
    changelog = "https://github.com/kpeeters/cadabra2/releases/tag/${finalAttrs.version}";
    homepage = "https://github.com/kpeeters/cadabra2";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ moraxyc ];
    mainProgram = "cadabra2";
    platforms = lib.platforms.unix;
    # glibmm not found
    broken = stdenv.hostPlatform.isDarwin;
  };
})
