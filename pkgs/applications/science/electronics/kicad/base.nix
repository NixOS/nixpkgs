{ lib
, stdenv
, cmake
, libGLU
, libGL
, zlib
, wxGTK
, gtk3
, libX11
, gettext
, glew
, glm
, cairo
, curl
, openssl
, boost
, pkg-config
, doxygen
, graphviz
, pcre
, libpthreadstubs
, libXdmcp
, lndir
, unixODBC

, util-linux
, libselinux
, libsepol
, libthai
, libdatrie
, libxkbcommon
, libepoxy
, dbus
, at-spi2-core
, libXtst
, pcre2

, swig4
, python
, wxPython
, opencascade-occt
, libngspice
, valgrind

, stable
, baseName
, kicadSrc
, kicadVersion
, withOCC
, withNgspice
, withScripting
, withI18n
, withPCM
, debug
, sanitizeAddress
, sanitizeThreads
}:

assert lib.assertMsg (!(sanitizeAddress && sanitizeThreads))
  "'sanitizeAddress' and 'sanitizeThreads' are mutually exclusive, use one.";

let
  inherit (lib) optional optionals optionalString;
in
stdenv.mkDerivation rec {
  pname = "kicad-base";
  version = if (stable) then kicadVersion else builtins.substring 0 10 src.rev;

  src = kicadSrc;

  patches = [
    # upstream issue 12941 (attempted to upstream, but appreciably unacceptable)
    ./writable.patch
  ];

  # tagged releases don't have "unknown"
  # kicad nightlies use git describe --dirty
  # nix removes .git, so its approximated here
  postPatch = if (!stable) then ''
    substituteInPlace cmake/KiCadVersion.cmake \
      --replace "unknown" "${builtins.substring 0 10 src.rev}"
  ''
  else "";

  makeFlags = optionals (debug) [ "CFLAGS+=-Og" "CFLAGS+=-ggdb" ];

  cmakeFlags = [
    # RPATH of binary /nix/store/.../bin/... contains a forbidden reference to /build/
    "-DCMAKE_SKIP_BUILD_RPATH=ON"
    "-DKICAD_USE_EGL=ON"
  ]
  ++ optionals (withScripting) [
    "-DKICAD_SCRIPTING_WXPYTHON=ON"
  ]
  ++ optionals (!withScripting) [
    "-DKICAD_SCRIPTING_WXPYTHON=OFF"
  ]
  ++ optional (!withNgspice) "-DKICAD_SPICE=OFF"
  ++ optional (!withOCC) "-DKICAD_USE_OCC=OFF"
  ++ optionals (withOCC) [
    "-DKICAD_USE_OCC=ON"
    "-DOCC_INCLUDE_DIR=${opencascade-occt}/include/opencascade"
  ]
  ++ optionals (debug) [
    "-DCMAKE_BUILD_TYPE=Debug"
    "-DKICAD_STDLIB_DEBUG=ON"
    "-DKICAD_USE_VALGRIND=ON"
  ]
  ++ optionals (!doInstallCheck) [
    "-DKICAD_BUILD_QA_TESTS=OFF"
  ]
  ++ optionals (sanitizeAddress) [
    "-DKICAD_SANITIZE_ADDRESS=ON"
  ]
  ++ optionals (sanitizeThreads) [
    "-DKICAD_SANITIZE_THREADS=ON"
  ]
  ++ optionals (withI18n) [
    "-DKICAD_BUILD_I18N=ON"
  ]
  ++ optionals (!withPCM && stable) [
    "-DKICAD_PCM=OFF"
  ]
  ++ optionals (!stable) [ # upstream issue 12491
    "-DCMAKE_CTEST_ARGUMENTS='--exclude-regex;qa_eeschema'"
  ];

  nativeBuildInputs = [
    cmake
    doxygen
    graphviz
    pkg-config
    lndir
  ]
  # wanted by configuration on linux, doesn't seem to affect performance
  # no effect on closure size
  ++ optionals (stdenv.isLinux) [
    util-linux
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
    pcre
    libXdmcp
    gettext
    glew
    glm
    libpthreadstubs
    cairo
    curl
    openssl
    boost
    swig4
    python
  ]
  ++ optional (!stable) unixODBC
  ++ optional (withScripting) wxPython
  ++ optional (withNgspice) libngspice
  ++ optional (withOCC) opencascade-occt
  ++ optional (debug) valgrind;

  # debug builds fail all but the python test
  doInstallCheck = !(debug);
  installCheckTarget = "test";

  dontStrip = debug;

  meta = {
    description = "Just the built source without the libraries";
    longDescription = ''
      Just the build products, the libraries are passed via an env var in the wrapper, default.nix
    '';
    homepage = "https://www.kicad.org/";
    license = lib.licenses.agpl3;
    platforms = lib.platforms.all;
  };
}
