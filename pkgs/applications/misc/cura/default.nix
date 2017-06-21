{ mkDerivation, lib, fetchFromGitHub, cmake, python3, qtbase, curaengine }:

mkDerivation rec {
  name = "cura-${version}";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "Ultimaker";
    repo = "Cura";
    rev = version;
    sha256 = "04iglmjg9rzmlfrll6g7bcckkla327938xh8qmbdfrh215aivdlp";
  };

  buildInputs = [ qtbase ];
  propagatedBuildInputs = with python3.pkgs; [ uranium zeroconf pyserial ];
  nativeBuildInputs = [ cmake python3.pkgs.wrapPython ];

  cmakeFlags = [ "-DCMAKE_MODULE_PATH=${python3.pkgs.uranium}/share/cmake-${cmake.majorVersion}/Modules" ];

  postPatch = ''
    sed -i 's,/python''${PYTHON_VERSION_MAJOR}/dist-packages,/python''${PYTHON_VERSION_MAJOR}.''${PYTHON_VERSION_MINOR}/site-packages,g' CMakeLists.txt
    sed -i 's, executable_name = .*, executable_name = "${curaengine}/bin/CuraEngine",' plugins/CuraEngineBackend/CuraEngineBackend.py
  '';

  postFixup = ''
    wrapPythonPrograms
  '';

  meta = with lib; {
    description = "3D printer / slicing GUI built on top of the Uranium framework";
    homepage = "https://github.com/Ultimaker/Cura";
    license = licenses.agpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
