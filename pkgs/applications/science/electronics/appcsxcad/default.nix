{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, csxcad
, qcsxcad
, hdf5
, vtk_8_withQt5
, qtbase
, fparser
, tinyxml
, cgal
, boost
}:

mkDerivation {
  pname = "appcsxcad";
  version = "unstable-2020-01-04";

  src = fetchFromGitHub {
    owner = "thliebig";
    repo = "AppCSXCAD";
    rev = "de8c271ec8b57e80233cb2a432e3d7fd54d30876";
    sha256 = "0shnfa0if3w588a68gr82qi6k7ldg1j2921fnzji90mmay21birp";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    csxcad
    qcsxcad
    hdf5
    vtk_8_withQt5
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
    homepage = "https://github.com/thliebig/AppCSXCAD";
    license = licenses.gpl3;
    maintainers = with maintainers; [ matthuszagh ];
    platforms = platforms.linux;
  };
}
