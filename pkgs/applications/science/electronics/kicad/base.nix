{ lib, stdenv, fetchFromGitLab, cmake, libGLU, libGL, zlib, wxGTK
, libX11, gettext, glew, glm, cairo, curl, openssl, boost, pkgconfig
, doxygen, pcre, libpthreadstubs, libXdmcp, fetchpatch, lndir, callPackages

, stable ? true
, baseName ? "kicad"
, versions ? { }
, oceSupport ? false, opencascade
, withOCCT ? true, opencascade-occt
, ngspiceSupport ? true, libngspice
, scriptingSupport ? true, swig, python, wxPython
, debug ? false, valgrind
, withI18n ? true
}:

assert ngspiceSupport -> libngspice != null;

with lib;
let

  versionConfig = versions.${baseName};

  # oce on aarch64 fails a test
  withOCE = oceSupport && !stdenv.isAarch64;
  withOCC = (withOCCT && !withOCE) || (oceSupport && stdenv.isAarch64);

  libraries = callPackages ./libraries.nix versionConfig.libVersion;

in
stdenv.mkDerivation rec {

  i18n = libraries.i18n;

  pname = "kicad-base";
  version = "${versions.${baseName}.kicadVersion.version}";

  src = fetchFromGitLab (
    {
      group = "kicad";
      owner = "code";
      repo = "kicad";
    } // versionConfig.kicadVersion.src
  );

  # quick fix for #72248
  # should be removed if a a more permanent fix is published
  patches = [
    (
      fetchpatch {
        url = "https://github.com/johnbeard/kicad/commit/dfb1318a3989e3d6f9f2ac33c924ca5030ea273b.patch";
        sha256 = "00ifd3fas8lid8svzh1w67xc8kyx89qidp7gm633r014j3kjkgcd";
      }
    )
  ];

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
    optionals (scriptingSupport) [
      "-DKICAD_SCRIPTING=ON"
      "-DKICAD_SCRIPTING_MODULES=ON"
      "-DKICAD_SCRIPTING_PYTHON3=ON"
      "-DKICAD_SCRIPTING_WXPYTHON_PHOENIX=ON"
    ]
    ++ optional (!scriptingSupport)
      "-DKICAD_SCRIPTING=OFF"
    ++ optional (ngspiceSupport) "-DKICAD_SPICE=ON"
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
    libGLU libGL zlib libX11 wxGTK pcre libXdmcp gettext
    glew glm libpthreadstubs cairo curl openssl boost
  ]
  ++ optionals (scriptingSupport) [ swig python wxPython ]
  ++ optional (ngspiceSupport) libngspice
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
    license = licenses.agpl3;
    platforms = platforms.all;
  };
}
