{
  lib,
  stdenv,
  cmake,
  libGLU,
  libGL,
  zlib,
  wxGTK,
  gtk3,
  libX11,
  gettext,
  glew,
  glm,
  cairo,
  curl,
  openssl,
  boost,
  pkg-config,
  doxygen,
  graphviz,
  libpthreadstubs,
  libXdmcp,
  unixODBC,
  libgit2,
  libsecret,
  libgcrypt,
  libgpg-error,
  ninja,
  writableTmpDirAsHomeHook,

  util-linuxMinimal,
  libselinux,
  libsepol,
  libthai,
  libdatrie,
  libxkbcommon,
  libepoxy,
  dbus,
  at-spi2-core,
  libXtst,
  pcre2,
  libdeflate,

  swig,
  python,
  wxPython,
  opencascade-occt_7_6,
  libngspice,
  valgrind,
  protobuf_29,
  nng,

  stable,
  testing,
  kicadSrc,
  kicadVersion,
  withNgspice,
  withScripting,
  withI18n,
  debug,
  sanitizeAddress,
  sanitizeThreads,
}:

assert lib.assertMsg (
  !(sanitizeAddress && sanitizeThreads)
) "'sanitizeAddress' and 'sanitizeThreads' are mutually exclusive, use one.";
assert testing -> !stable -> throw "testing implies stable and cannot be used with stable = false";

let
  opencascade-occt = opencascade-occt_7_6;
  inherit (lib)
    cmakeBool
    cmakeFeature
    optionals
    optionalString
    ;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "kicad-base";
  version = if stable then kicadVersion else builtins.substring 0 10 finalAttrs.src.rev;

  src = kicadSrc;

  patches = [
    # upstream issue 12941 (attempted to upstream, but appreciably unacceptable)
    ./writable.patch
    # https://gitlab.com/kicad/code/kicad/-/issues/15687
    ./runtime_stock_data_path.patch
  ];

  # tagged releases don't have "unknown"
  # kicad testing and nightlies use git describe --dirty
  # nix removes .git, so its approximated here
  postPatch = lib.optionalString (!stable || testing) ''
    substituteInPlace cmake/KiCadVersion.cmake \
      --replace-fail "unknown" "${builtins.substring 0 10 finalAttrs.src.rev}"

    substituteInPlace cmake/CreateGitVersionHeader.cmake \
      --replace-fail "0000000000000000000000000000000000000000" "${finalAttrs.src.rev}"
  '';

  preConfigure = optionalString debug ''
    export CFLAGS="''${CFLAGS:-} -Og -ggdb"
    export CXXFLAGS="''${CXXFLAGS:-} -Og -ggdb"
  '';

  cmakeFlags = [
    (cmakeBool "KICAD_USE_EGL" true)
    (cmakeFeature "OCC_INCLUDE_DIR" "${opencascade-occt}/include/opencascade")
    # https://gitlab.com/kicad/code/kicad/-/issues/17133
    (cmakeFeature "CMAKE_CTEST_ARGUMENTS" "--exclude-regex;qa_spice")
    (cmakeBool "KICAD_USE_CMAKE_FINDPROTOBUF" false)
    (cmakeBool "KICAD_SCRIPTING_WXPYTHON" withScripting)
    (cmakeBool "KICAD_BUILD_I18N" withI18n)
    (cmakeBool "KICAD_BUILD_QA_TESTS" (!finalAttrs.doInstallCheck))
    (cmakeBool "KICAD_STDLIB_DEBUG" debug)
    (cmakeBool "KICAD_USE_VALGRIND" debug)
    (cmakeBool "KICAD_SANITIZE_ADDRESS" sanitizeAddress)
    (cmakeBool "KICAD_SANITIZE_THREADS" sanitizeThreads)
    (cmakeBool "KICAD_SPICE" (!(stable && !withNgspice)))
  ]
  ++ optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
    (cmakeFeature "CMAKE_CTEST_ARGUMENTS" "--exclude-regex;'qa_spice|qa_cli'")
  ];

  cmakeBuildType = if debug then "Debug" else "Release";

  nativeBuildInputs = [
    cmake
    ninja
    doxygen
    graphviz
    pkg-config
    libgit2
    libsecret
    libgcrypt
    libgpg-error
  ]
  # wanted by configuration on linux, doesn't seem to affect performance
  # no effect on closure size
  ++ optionals (stdenv.hostPlatform.isLinux) [
    util-linuxMinimal
    libselinux
    libsepol
    libthai
    libdatrie
    libxkbcommon
    libepoxy
    dbus
    at-spi2-core
    libXtst
    pcre2
  ];

  buildInputs = [
    libGLU
    libGL
    zlib
    libX11
    wxGTK
    gtk3
    libXdmcp
    gettext
    glew
    glm
    libpthreadstubs
    cairo
    curl
    openssl
    boost
    swig
    python
    unixODBC
    libdeflate
    opencascade-occt
    protobuf_29

    # This would otherwise cause a linking requirement for mbedtls.
    (nng.override { mbedtlsSupport = false; })
  ]
  ++ optionals withScripting [ wxPython ]
  ++ optionals withNgspice [ libngspice ]
  ++ optionals debug [ valgrind ];

  # debug builds fail all but the python test
  doInstallCheck = !debug;
  installCheckTarget = "test";

  nativeInstallCheckInputs = [
    (python.withPackages (
      ps: with ps; [
        numpy
        pytest
        cairosvg
        pytest-image-diff
      ]
    ))
    writableTmpDirAsHomeHook
  ];

  dontStrip = debug;

  meta = {
    description = "Just the built source without the libraries";
    longDescription = ''
      Just the build products, the libraries are passed via an env var in the wrapper, default.nix
    '';
    homepage = "https://www.kicad.org/";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    broken = stdenv.hostPlatform.isDarwin;
  };
})
