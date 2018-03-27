{ wxGTK, lib, stdenv, fetchFromGitHub, cmake, libGLU_combined, zlib
, libX11, gettext, glew, glm, cairo, curl, openssl, boost, pkgconfig
, doxygen, pcre, libpthreadstubs, libXdmcp

, oceSupport ? true, opencascade_oce
, ngspiceSupport ? true, libngspice
, scriptingSupport ? true, swig, python, wxPython
}:

assert ngspiceSupport -> libngspice != null;

with lib;
stdenv.mkDerivation rec {
  name = "kicad-unstable-${version}";
  version = "2018-03-10";

  src = fetchFromGitHub {
    owner = "KICad";
    repo = "kicad-source-mirror";
    rev = "17c0917dac12ea0be50ff95cee374a0cd8b7f862";
    sha256 = "1yn5hj5hjnpb5fkzzlyawg62a96fbfvha49395s22dcp95riqvf0";
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
    ++ optional (ngspiceSupport) libngspice
    ++ optionals (scriptingSupport) [ swig python wxPython ];

  meta = {
    description = "Free Software EDA Suite, Nightly Development Build";
    homepage = http://www.kicad-pcb.org/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ berce ];
    platforms = with platforms; linux;
  };
}
