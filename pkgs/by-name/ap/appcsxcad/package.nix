{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  csxcad,
  qcsxcad,
  hdf5,
  vtkWithQt6,
  qt6,
  fparser,
  tinyxml,
  cgal,
  boost,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "appcsxcad";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "thliebig";
    repo = "AppCSXCAD";
    rev = "v${finalAttrs.version}";
    hash = "sha256-KrsnCnRZRTbkgEH3hOETrYhseg5mCHPqhAbYyHlS3sk=";
  };

  nativeBuildInputs = [
    cmake
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    csxcad
    qcsxcad
    hdf5
    vtkWithQt6
    qt6.qtbase
    qt6.qtwayland
    fparser
    tinyxml
    cgal
    boost
  ];

  postFixup = ''
    rm $out/bin/AppCSXCAD.sh
  '';

  meta = {
    description = "Minimal Application using the QCSXCAD library";
    mainProgram = "AppCSXCAD";
    homepage = "https://github.com/thliebig/AppCSXCAD";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ matthuszagh ];
    platforms = lib.platforms.linux;
  };
})
