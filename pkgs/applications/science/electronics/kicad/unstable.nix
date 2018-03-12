{ wxGTK, lib, stdenv, fetchFromGitHub, cmake, libGLU_combined, zlib
, libX11, gettext, glew, glm, cairo, curl, openssl, boost, pkgconfig
, doxygen, pcre, libpthreadstubs, libXdmcp

, oceSupport ? true, opencascade_oce
, ngspiceSupport ? true, ngspice
, scriptingSupport ? true, swig, python, wxPython
}:

with lib;
stdenv.mkDerivation rec {
  name = "kicad-unstable-${version}";
  version = "2017-12-11";

  src = fetchFromGitHub {
    owner = "KICad";
    repo = "kicad-source-mirror";
    rev = "1955f252265c38a313f6c595d6c4c637f38fd316";
    sha256 = "15cc81h7nh5dk6gj6mc4ylcgdznfriilhb43n1g3xwyq3s8iaibz";
  };

  postPatch = ''
    substituteInPlace CMakeModules/KiCadVersion.cmake \
      --replace no-vcs-found ${version}
  '';

  cmakeFlags =
    optionals (oceSupport) [ "-DKICAD_USE_OCE=ON" "-DOCE_DIR=${opencascade_oce}" ]
    ++ optional (ngspiceSupport) "-DKICAD_SPICE=ON"
    ++ optionals (scriptingSupport) [
      "-DKICAD_SCRIPTING=ON"
      "-DKICAD_SCRIPTING_MODULES=ON"
      "-DKICAD_SCRIPTING_WXPYTHON=ON"
      # nix installs wxPython headers in wxPython package, not in wxwidget
      # as assumed. We explicitely set the header location.
      "-DCMAKE_CXX_FLAGS=-I${wxPython}/include/wx-3.0"
    ];

  nativeBuildInputs = [ cmake doxygen  pkgconfig ];
  buildInputs = [
    libGLU_combined zlib libX11 wxGTK pcre libXdmcp gettext glew glm libpthreadstubs
    cairo curl openssl boost
  ] ++ optional (oceSupport) opencascade_oce
    ++ optional (ngspiceSupport) ngspice
    ++ optionals (scriptingSupport) [ swig python wxPython ];

  meta = {
    description = "Free Software EDA Suite, Nightly Development Build";
    homepage = http://www.kicad-pcb.org/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ berce ];
    platforms = with platforms; linux;
  };
}
