{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
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

  patches = [
    # ref. https://github.com/thliebig/AppCSXCAD/pull/14 merged upstream
    (fetchpatch {
      name = "update-minimum-cmake-required.patch";
      url = "https://github.com/thliebig/AppCSXCAD/commit/9585207eb08195c3f1c47dc9d6a80b563a3272e0.patch";
      hash = "sha256-2+C3cqQMU3UL12h0f7EdBZVqeJVSPhDVbMOcqbOY0gg=";
    })
    (fetchpatch {
      name = "remove-cmp0020-policy.patch";
      url = "https://github.com/thliebig/AppCSXCAD/commit/688c07cd847f463a2a42f01d41751374b4f787c8.patch";
      hash = "sha256-pa6imzrUoVA3Ebc4UGPACJ6qjYiHOjB5aQ9FN/CUpVM=";
    })
  ];

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
