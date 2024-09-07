{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, csxcad
, qcsxcad
, hdf5
, vtkWithQt5
, qtbase
, fparser
, tinyxml
, cgal
, boost
}:

mkDerivation {
  pname = "appcsxcad";
  version = "unstable-2023-01-06";

  src = fetchFromGitHub {
    owner = "thliebig";
    repo = "AppCSXCAD";
    rev = "379ede4b8e00c11e8d0fb724c35547991b30c423";
    hash = "sha256-L0ZEyovnfMzM7JuITBuhb4tJ2Aqgw52IiKEfEGq7Yo0=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    csxcad
    qcsxcad
    hdf5
    vtkWithQt5
    qtbase
    fparser
    tinyxml
    cgal
    boost
  ];

  postFixup = ''
    rm $out/bin/AppCSXCAD.sh
  '';

  meta = with lib; {
    description = "Minimal Application using the QCSXCAD library";
    mainProgram = "AppCSXCAD";
    homepage = "https://github.com/thliebig/AppCSXCAD";
    license = licenses.gpl3;
    maintainers = with maintainers; [ matthuszagh ];
    platforms = platforms.linux;
  };
}
