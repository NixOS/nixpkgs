{ stdenv
, fetchFromGitLab
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
, pkgconfig
, doxygen
, pcre
, libpthreadstubs
, libXdmcp
, fetchpatch
, lndir
, callPackage

, stable
, baseName
, kicadSrc
, kicadVersion
, i18n
, withOCE
, opencascade
, withOCC
, opencascade-occt
, withNgspice
, libngspice
, withScripting
, swig
, python
, wxPython
, debug
, valgrind
, withI18n
, gtk3
}:

assert stdenv.lib.asserts.assertMsg (!(withOCE && stdenv.isAarch64)) "OCE fails a test on Aarch64";
assert stdenv.lib.asserts.assertMsg (!(withOCC && withOCE))
  "Only one of OCC and OCE may be enabled";
let
  inherit (stdenv.lib) optional optionals;
in
stdenv.mkDerivation rec {
  pname = "kicad-base";
  version = kicadVersion;

  src = kicadSrc;

  # tagged releases don't have "unknown"
  # kicad nightlies use git describe --dirty
  # nix removes .git, so its approximated here
  # "-1" appended to indicate we're adding a patch
  postPatch = ''
    substituteInPlace CMakeModules/KiCadVersion.cmake \
      --replace "unknown" "${builtins.substring 0 10 src.rev}-1" \
      --replace "${version}" "${version}-1"
  '';

  makeFlags = optional (debug) [ "CFLAGS+=-Og" "CFLAGS+=-ggdb" ];

  cmakeFlags =
    optionals (withScripting) [
      "-DKICAD_SCRIPTING=ON"
      "-DKICAD_SCRIPTING_MODULES=ON"
      "-DKICAD_SCRIPTING_PYTHON3=ON"
      "-DKICAD_SCRIPTING_WXPYTHON_PHOENIX=ON"
    ]
    ++ optional (!withScripting)
      "-DKICAD_SCRIPTING=OFF"
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
  ;

  nativeBuildInputs = [ cmake doxygen pkgconfig lndir ];

  buildInputs = [
    libGLU
    libGL
    zlib
    libX11
    wxGTK
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
    gtk3
  ]
  ++ optionals (withScripting) [ swig python wxPython ]
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

  postInstall = optional (withI18n) ''
    mkdir -p $out/share
    lndir ${i18n}/share $out/share
  '';

  meta = {
    description = "Just the built source without the libraries";
    longDescription = ''
      Just the build products, optionally with the i18n linked in
      the libraries are passed via an env var in the wrapper, default.nix
    '';
    homepage = "https://www.kicad-pcb.org/";
    license = stdenv.lib.licenses.agpl3;
    platforms = stdenv.lib.platforms.all;
  };
}
