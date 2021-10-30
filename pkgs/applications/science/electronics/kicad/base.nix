{ lib
, stdenv
, cmake
, libGLU
, libGL
, zlib
, wxGTK
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

, util-linux
, libselinux
, libsepol
, libthai
, libdatrie
, libxkbcommon
, epoxy
, dbus
, at-spi2-core
, libXtst

, swig
, python
, wxPython
, opencascade
, opencascade-occt
, libngspice
, valgrind

, stable
, baseName
, kicadSrc
, kicadVersion
, i18n
, withOCE
, withOCC
, withNgspice
, withScripting
, debug
, sanitizeAddress
, sanitizeThreads
, withI18n
}:

assert lib.asserts.assertMsg (!(withOCE && stdenv.isAarch64)) "OCE fails a test on Aarch64";
assert lib.asserts.assertMsg (!(withOCC && withOCE))
  "Only one of OCC and OCE may be enabled";
assert lib.assertMsg (!(stable && (sanitizeAddress || sanitizeThreads)))
  "Only kicad-unstable(-small) supports address/thread sanitation";
assert lib.assertMsg (!(sanitizeAddress && sanitizeThreads))
  "'sanitizeAddress' and 'sanitizeThreads' are mutually exclusive, use one.";

let
  inherit (lib) optional optionals optionalString;
in
stdenv.mkDerivation rec {
  pname = "kicad-base";
  version = if (stable) then kicadVersion else builtins.substring 0 10 src.rev;

  src = kicadSrc;

  # tagged releases don't have "unknown"
  # kicad nightlies use git describe --dirty
  # nix removes .git, so its approximated here
  postPatch = ''
    substituteInPlace CMakeModules/KiCadVersion.cmake \
      --replace "unknown" "${builtins.substring 0 10 src.rev}" \
  '';

  makeFlags = optionals (debug) [ "CFLAGS+=-Og" "CFLAGS+=-ggdb" ];

  cmakeFlags = optionals (stable && withScripting) [
    "-DKICAD_SCRIPTING=ON"
    "-DKICAD_SCRIPTING_MODULES=ON"
    "-DKICAD_SCRIPTING_PYTHON3=ON"
    "-DKICAD_SCRIPTING_WXPYTHON_PHOENIX=ON"
  ]
  ++ optionals (!withScripting) [
    "-DKICAD_SCRIPTING=OFF"
    "-DKICAD_SCRIPTING_WXPYTHON=OFF"
  ]
  ++ optional (withNgspice) "-DKICAD_SPICE=ON"
  ++ optional (!withOCE) "-DKICAD_USE_OCE=OFF"
  ++ optional (!withOCC) "-DKICAD_USE_OCC=OFF"
  ++ optionals (withOCE) [
    "-DKICAD_USE_OCE=ON"
    "-DOCE_DIR=${opencascade}"
  ]
  ++ optionals (withOCC) [
    "-DKICAD_USE_OCC=ON"
    "-DOCC_INCLUDE_DIR=${opencascade-occt}/include/opencascade"
  ]
  ++ optionals (debug) [
    "-DCMAKE_BUILD_TYPE=Debug"
    "-DKICAD_STDLIB_DEBUG=ON"
    "-DKICAD_USE_VALGRIND=ON"
  ]
  ++ optionals (sanitizeAddress) [
    "-DKICAD_SANITIZE_ADDRESS=ON"
  ]
  ++ optionals (sanitizeThreads) [
    "-DKICAD_SANITIZE_THREADS=ON"
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
    epoxy
    dbus.daemon
    at-spi2-core
    libXtst
  ];

  buildInputs = [
    libGLU
    libGL
    zlib
    libX11
    wxGTK
    wxGTK.gtk
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
  ]
  # unstable requires swig and python
  # wxPython still optional
  ++ optionals (withScripting || (!stable)) [ swig python ]
  ++ optional (withScripting) wxPython
  ++ optional (withNgspice) libngspice
  ++ optional (withOCE) opencascade
  ++ optional (withOCC) opencascade-occt
  ++ optional (debug) valgrind
  ;

  # debug builds fail all but the python test
  # 5.1.x fails the eeschema test
  doInstallCheck = !debug && !stable;
  installCheckTarget = "test";

  dontStrip = debug;

  postInstall = optionalString (withI18n) ''
    mkdir -p $out/share
    lndir ${i18n}/share $out/share
  '';

  meta = {
    description = "Just the built source without the libraries";
    longDescription = ''
      Just the build products, optionally with the i18n linked in
      the libraries are passed via an env var in the wrapper, default.nix
    '';
    homepage = "https://www.kicad.org/";
    license = lib.licenses.agpl3;
    platforms = lib.platforms.all;
  };
}
