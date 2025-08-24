{
  lib,
  stdenv,
  fetchFromGitHub,
  makeDesktopItem,
  copyDesktopItems,
  cmake,
  boost,
  cgal,
  eigen,
  flann,
  gdal,
  gmp,
  laszip,
  mpfr,
  pcl,
  libsForQt5,
  tbb,
  xercesc,
  wrapGAppsHook3,
}:

stdenv.mkDerivation rec {
  pname = "cloudcompare";
  version = "2.13.2";

  src = fetchFromGitHub {
    owner = "CloudCompare";
    repo = "CloudCompare";
    tag = "v${version}";
    hash = "sha256-a/0lf3Mt5ZpLFRM8jAoqZer8pY1ROgPRY4dPt34Bk3E=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    eigen # header-only
    wrapGAppsHook3
    copyDesktopItems
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = [
    boost
    cgal
    flann
    gdal
    gmp
    laszip
    mpfr
    pcl
    libsForQt5.qtbase
    libsForQt5.qtsvg
    libsForQt5.qttools
    tbb
    xercesc
  ];

  cmakeFlags = [
    "-DCCCORELIB_USE_TBB=ON"
    "-DOPTION_USE_DXF_LIB=ON"
    "-DOPTION_USE_GDAL=ON"
    "-DOPTION_USE_SHAPE_LIB=ON"

    "-DPLUGIN_GL_QEDL=ON"
    "-DPLUGIN_GL_QSSAO=ON"

    "-DPLUGIN_IO_QADDITIONAL=ON"
    "-DPLUGIN_IO_QCORE=ON"
    "-DPLUGIN_IO_QCSV_MATRIX=ON"
    "-DPLUGIN_IO_QE57=ON"
    "-DPLUGIN_IO_QFBX=OFF" # Autodesk FBX SDK is gratis+proprietary; not packaged in nixpkgs
    "-DPLUGIN_IO_QLAS=ON" # required for .las/.laz support
    "-DPLUGIN_IO_QPHOTOSCAN=ON"
    "-DPLUGIN_IO_QRDB=OFF" # Riegl rdblib is proprietary; not packaged in nixpkgs

    "-DCCCORELIB_USE_CGAL=ON" # enables Delauney triangulation support
    "-DPLUGIN_STANDARD_QPCL=ON" # Adds PCD import and export support
    "-DPLUGIN_STANDARD_QANIMATION=ON"
    "-DPLUGIN_STANDARD_QBROOM=ON"
    "-DPLUGIN_STANDARD_QCANUPO=ON"
    "-DPLUGIN_STANDARD_QCOMPASS=ON"
    "-DPLUGIN_STANDARD_QCSF=ON"
    "-DPLUGIN_STANDARD_QFACETS=ON"
    "-DPLUGIN_STANDARD_QHOUGH_NORMALS=ON"
    "-DEIGEN_ROOT_DIR=${eigen}/include/eigen3" # needed for hough normals
    "-DPLUGIN_STANDARD_QHPR=ON"
    "-DPLUGIN_STANDARD_QM3C2=ON"
    "-DPLUGIN_STANDARD_QMPLANE=ON"
    "-DPLUGIN_STANDARD_QPOISSON_RECON=ON"
    "-DPLUGIN_STANDARD_QRANSAC_SD=OFF" # not compatible with GPL, broken on non-x86
    "-DPLUGIN_STANDARD_QSRA=ON"
    "-DPLUGIN_STANDARD_QCLOUDLAYERS=ON"
  ];

  dontWrapGApps = true;

  postInstall = ''
    install -Dm444 $src/qCC/images/icon/cc_icon_16.png $out/share/icons/hicolor/16x16/apps/CloudCompare.png
    install -Dm444 $src/qCC/images/icon/cc_icon_32.png $out/share/icons/hicolor/32x32/apps/CloudCompare.png
    install -Dm444 $src/qCC/images/icon/cc_icon_64.png $out/share/icons/hicolor/64x64/apps/CloudCompare.png
    install -Dm444 $src/qCC/images/icon/cc_icon_256.png $out/share/icons/hicolor/256x256/apps/CloudCompare.png

    install -Dm444 $src/qCC/images/icon/cc_viewer_icon_16.png $out/share/icons/hicolor/16x16/apps/ccViewer.png
    install -Dm444 $src/qCC/images/icon/cc_viewer_icon_32.png $out/share/icons/hicolor/32x32/apps/ccViewer.png
    install -Dm444 $src/qCC/images/icon/cc_viewer_icon_64.png $out/share/icons/hicolor/64x64/apps/ccViewer.png
    install -Dm444 $src/qCC/images/icon/cc_viewer_icon_256.png $out/share/icons/hicolor/256x256/apps/ccViewer.png
  '';

  # fix file dialogs crashing on non-NixOS (and avoid double wrapping)
  preFixup = ''
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "CloudCompare";
      desktopName = "CloudCompare";
      comment = "3D point cloud and mesh processing software";
      exec = "CloudCompare";
      terminal = false;
      categories = [
        "Graphics"
        "3DGraphics"
        "Viewer"
      ];
      keywords = [
        "3d"
        "processing"
      ];
      icon = "CloudCompare";
    })
    (makeDesktopItem {
      name = "ccViewer";
      desktopName = "CloudCompare Viewer";
      comment = "3D point cloud and mesh processing software";
      exec = "ccViewer";
      terminal = false;
      categories = [
        "Graphics"
        "3DGraphics"
        "Viewer"
      ];
      keywords = [
        "3d"
        "viewer"
      ];
      icon = "ccViewer";
    })
  ];

  meta = with lib; {
    description = "3D point cloud and mesh processing software";
    homepage = "https://cloudcompare.org";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ nh2 ];
    mainProgram = "CloudCompare";
    platforms = with platforms; linux; # only tested here; might work on others
  };
}
