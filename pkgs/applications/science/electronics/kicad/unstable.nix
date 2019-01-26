{ wxGTK, lib, stdenv, fetchFromGitHub, cmake, libGLU_combined, zlib
, libX11, gettext, glew, glm, cairo, curl, openssl, boost, pkgconfig
, doxygen, pcre, libpthreadstubs, libXdmcp

, oceSupport ? true, opencascade
, ngspiceSupport ? true, libngspice
, scriptingSupport ? true, swig, python, wxPython
}:

assert ngspiceSupport -> libngspice != null;

with lib;
stdenv.mkDerivation rec {
  name = "kicad-unstable-${version}";
  version = "2018-06-12";

  src = fetchFromGitHub {
    owner = "KICad";
    repo = "kicad-source-mirror";
    rev = "bc7bd107d980da147ad515aeae0469ddd55c2368";
    sha256 = "11nsx52pd3jr2wbzr11glmcs1a9r7z1mqkqx6yvlm0awbgd8qlv8";
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

  nativeBuildInputs = [ cmake doxygen pkgconfig ];
  buildInputs = [
    libGLU_combined zlib libX11 wxGTK pcre libXdmcp gettext glew glm libpthreadstubs
    cairo curl openssl boost
  ] ++ optional (oceSupport) opencascade
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
