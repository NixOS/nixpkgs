{ wxGTK, lib, stdenv, fetchurl, cmake, libGLU_combined, zlib
, libX11, gettext, glew, glm, cairo, curl, openssl, boost, pkgconfig
, doxygen, pcre, libpthreadstubs, libXdmcp

, oceSupport ? true, opencascade
, ngspiceSupport ? true, libngspice
, scriptingSupport ? true, swig, python, wxPython
}:

assert ngspiceSupport -> libngspice != null;

with lib;
stdenv.mkDerivation rec {
  name = "kicad-${version}";
  series = "5.0";
  version = "5.0.0";

  src = fetchurl {
    url = "https://launchpad.net/kicad/${series}/${version}/+download/kicad-${version}.tar.xz";
    sha256 = "17nqjszyvd25wi6550j981whlnb1wxzmlanljdjihiki53j84x9p";
  };

  postPatch = ''
    substituteInPlace CMakeModules/KiCadVersion.cmake \
      --replace no-vcs-found ${version}
  '';

  cmakeFlags =
    optionals (oceSupport) [ "-DKICAD_USE_OCE=ON" "-DOCE_DIR=${opencascade}" ]
    ++ optional (ngspiceSupport) "-DKICAD_SPICE=ON"
    ++ optionals (scriptingSupport) [
      "-DKICAD_SCRIPTING=ON"
      "-DKICAD_SCRIPTING_MODULES=ON"
      "-DKICAD_SCRIPTING_WXPYTHON=ON"
      # nix installs wxPython headers in wxPython package, not in wxwidget
      # as assumed. We explicitely set the header location.
      "-DCMAKE_CXX_FLAGS=-I${wxPython}/include/wx-3.0"
    ];

  # https://www.mail-archive.com/kicad-developers@lists.launchpad.net/msg29840.html
  nativeBuildInputs = [ (cmake.override {majorVersion = "3.10";}) doxygen  pkgconfig ];
  buildInputs = [
    libGLU_combined zlib libX11 wxGTK pcre libXdmcp gettext glew glm libpthreadstubs
    cairo curl openssl boost
  ] ++ optional (oceSupport) opencascade
    ++ optional (ngspiceSupport) libngspice
    ++ optionals (scriptingSupport) [ swig python wxPython ];

  meta = {
    description = "Free Software EDA Suite";
    homepage = http://www.kicad-pcb.org/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ berce ];
    platforms = with platforms; linux;
  };
}
