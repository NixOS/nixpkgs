{ lib, mkDerivation, fetchFromGitHub, fetchpatch
, cmake, qttools, kirigami2, qtquickcontrols2, qtlocation, qtsensors
, nemo-qml-plugin-dbus, mapbox-gl-qml, s2geometry, abseil-cpp
, python3, pyotherside
}:

mkDerivation rec {
  pname = "pure-maps";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "rinigus";
    repo = "pure-maps";
    rev = version;
    hash = "sha256-TeFolD3jXRdLGfXdy+QcwtOcQQVUB5fn8PwoYfRLaPQ=";
    fetchSubmodules = true;
  };

  patches = [
    # Fix build failure with s2geometry 0.11.1
    (fetchpatch {
      url = "https://github.com/rinigus/pure-maps/commit/9f1e3124cf876ca5ab26d717a34e8d925834b044.patch";
      hash = "sha256-N2FxxJ9qFTRi2cGXl85IySrmc9p6fR3ak9J9QsVzprQ=";
    })
  ];

  nativeBuildInputs = [
    cmake python3 qttools python3.pkgs.wrapPython
  ];

  buildInputs = [
    kirigami2 qtquickcontrols2 qtlocation qtsensors
    nemo-qml-plugin-dbus pyotherside mapbox-gl-qml s2geometry
    (abseil-cpp.override { cxxStandard = "14"; })
  ];

  cmakeFlags = [ "-DFLAVOR=kirigami" "-DCMAKE_CXX_STANDARD=14" ];

  pythonPath = with python3.pkgs; [ gpxpy ];

  preInstall = ''
    buildPythonPath "$pythonPath"
    qtWrapperArgs+=(--prefix PYTHONPATH : "$program_PYTHONPATH")
  '';

  meta = with lib; {
    description = "Display vector and raster maps, places, routes, and provide navigation instructions with a flexible selection of data and service providers";
    mainProgram = "pure-maps";
    homepage = "https://github.com/rinigus/pure-maps";
    changelog = "https://github.com/rinigus/pure-maps/blob/${src.rev}/NEWS.md";
    license = licenses.gpl3Only;
    maintainers = [ maintainers.Thra11 ];
    platforms = platforms.linux;
  };
}
