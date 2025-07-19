{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchzip,

  cmake,
  pkg-config,
  makeWrapper,
  wrapGAppsHook3,

  python3,
  glibmm,
  sqlite,
  boost,
  openssl,
  gmpxx,
  gtkmm3,
  libsysprof-capture,
  pcre2,

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
  # Use the system-provided jsoncpp library
  enableSystemJsonCpp ? false,
}:
let
  python = python3.withPackages (
    p: with p; [
      matplotlib
      mpmath
      sympy
      gmpy2
    ]
  );

  pname = "cadabra2";
  version = "2.5.10";

  # Upstream didnot init submodule correctly
  # TODO: remove at the next release (already on devel)
  MicroTeX = fetchzip {
    name = "MicroTeX";
    url = "https://github.com/kpeeters/MicroTeX/archive/f67453bb7a8e82736f4ce3b9d2ce919bdf24644e.zip";
    hash = "sha256-rW0XaSv22z0C6sAr5bnPEYyHUDri+H2dbpoKcqdN9Co=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "kpeeters";
    repo = "cadabra2";
    tag = version;
    hash = "sha256-7Br8hMwV7YdgQygHZGW99Z8TaRlXpAJ4hclqzRnjxjg=";
    # TODO: enable at the next release
    # fetchSubmodules = true;
  };

  postPatch = ''
    mkdir submodules
    cp -r ${MicroTeX} submodules/microtex
    chmod -R 775 submodules/microtex
  '';

  cmakeFlags = [
    "-DPYTHON_SITE_PATH=${placeholder "out"}/${python.sitePackages}"
    (lib.cmakeBool "USE_PYTHON_3" true)

    (lib.cmakeBool "ENABLE_FRONTEND" enableFrontend)
    (lib.cmakeBool "ENABLE_JUPYTER" enableJupyter)
    (lib.cmakeBool "ENABLE_PY_JUPYTER" enablePyJupyter)
    (lib.cmakeBool "ENABLE_MATHEMATICA" enableMathematica)
    (lib.cmakeBool "BUILD_AS_CPP_LIBRARY" enableBuildAsCppLibrary)
    (lib.cmakeBool "ENABLE_SYSTEM_JSONCPP" enableSystemJsonCpp)
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    makeWrapper
    wrapGAppsHook3
  ];

  buildInputs = [
    glibmm
    sqlite
    boost
    openssl
    gmpxx
    gtkmm3
    libsysprof-capture
    pcre2
  ];

  propagatedBuildInputs = [
    python
  ];

  postFixup = ''
    PYTHONPATH=$out/${python.sitePackages}:$PYTHONPATH
    for bin in $out/bin/*; do
      wrapProgram $bin \
        --prefix PYTHONPATH : "$PYTHONPATH" \
        --prefix PATH : "$out/bin"
    done
  '';

  meta = {
    description = "Field-theory motivated approach to computer algebra";
    changelog = "https://github.com/kpeeters/cadabra2/releases/tag/${version}";
    homepage = "https://github.com/kpeeters/cadabra2";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ moraxyc ];
    mainProgram = "cadabra2";
    platforms = lib.platforms.all;
  };
})
