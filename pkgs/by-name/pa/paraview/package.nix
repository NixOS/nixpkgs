{
  lib,
  stdenv,
  fetchurl,
  fetchzip,
  cmake,
  ninja,
  qt6Packages,
  protobuf,
  vtk-full,
}:
stdenv.mkDerivation (
  finalAttrs:
  let
    paraviewFilesUrl = "https://www.paraview.org/files/v${lib.versions.majorMinor finalAttrs.version}";
    doc = fetchurl {
      url = "${paraviewFilesUrl}/ParaViewGettingStarted-${finalAttrs.version}.pdf";
      name = "GettingStarted.pdf";
      hash = "sha256-2ghvb0UXa0Z/YGWzCchB1NKowRdlC/ZQCI3y0tZUdbo=";
    };
    examples = fetchzip {
      url = "${paraviewFilesUrl}/ParaView-${finalAttrs.version}-MPI-Linux-Python3.12-x86_64.tar.gz";
      hash = "sha256-y9ecUYkR44s5zC+scIxP3VS+O0sUm7ZBjCZ7Mxr4Y94=";
      postFetch = ''
        mv $out/share/paraview-${lib.versions.majorMinor finalAttrs.version}/examples .
        rm $out/* -rf
        mv examples $out
      '';
    };
  in
  {
    pname = "paraview";
    version = "6.0.0";

    src = fetchurl {
      url = "${paraviewFilesUrl}/ParaView-v${finalAttrs.version}.tar.xz";
      hash = "sha256-DuB65jd+Xpd2auv4WOuXWGaKUt8EHzGefJdQN6Y78Yk=";
    };

    # When building paraview with external vtk, we can not infer resource_dir
    # from the path of vtk's libraries. Thus hardcoding the resource_dir.
    # See https://gitlab.kitware.com/paraview/paraview/-/issues/23043.
    postPatch = ''
      substituteInPlace Remoting/Core/vtkPVFileInformation.cxx \
        --replace-fail "return resource_dir;" "return \"$out/share/paraview\";"
    '';

    nativeBuildInputs = [
      cmake
      ninja
      qt6Packages.wrapQtAppsHook
    ];

    buildInputs = [
      qt6Packages.qttools
      qt6Packages.qt5compat
      protobuf
    ];

    propagatedBuildInputs = [
      vtk-full
    ];

    cmakeFlags = [
      (lib.cmakeBool "PARAVIEW_VERSIONED_INSTALL" false)
      (lib.cmakeBool "PARAVIEW_BUILD_WITH_EXTERNAL" true)
      (lib.cmakeBool "PARAVIEW_USE_EXTERNAL_VTK" true)
      (lib.cmakeBool "PARAVIEW_USE_QT" true)
      (lib.cmakeBool "PARAVIEW_USE_MPI" true)
      (lib.cmakeBool "PARAVIEW_USE_PYTHON" true)
      (lib.cmakeBool "PARAVIEW_ENABLE_WEB" true)
      (lib.cmakeBool "PARAVIEW_ENABLE_CATALYST" true)
      (lib.cmakeBool "PARAVIEW_ENABLE_VISITBRIDGE" true)
      (lib.cmakeBool "PARAVIEW_ENABLE_ADIOS2" true)
      (lib.cmakeBool "PARAVIEW_ENABLE_FFMPEG" true)
      (lib.cmakeBool "PARAVIEW_ENABLE_FIDES" true)
      (lib.cmakeBool "PARAVIEW_ENABLE_ALEMBIC" true)
      (lib.cmakeBool "PARAVIEW_ENABLE_LAS" true)
      (lib.cmakeBool "PARAVIEW_ENABLE_GDAL" true)
      (lib.cmakeBool "PARAVIEW_ENABLE_PDAL" true)
      (lib.cmakeBool "PARAVIEW_ENABLE_OPENTURNS" true)
      (lib.cmakeBool "PARAVIEW_ENABLE_MOTIONFX" true)
      (lib.cmakeBool "PARAVIEW_ENABLE_OCCT" true)
      (lib.cmakeBool "PARAVIEW_ENABLE_XDMF3" true)
      (lib.cmakeFeature "CMAKE_INSTALL_BINDIR" "bin")
      (lib.cmakeFeature "CMAKE_INSTALL_LIBDIR" "lib")
      (lib.cmakeFeature "CMAKE_INSTALL_INCLUDEDIR" "include")
      (lib.cmakeFeature "CMAKE_INSTALL_DOCDIR" "share/paraview/doc")
    ];

    postInstall = ''
      install -Dm644 ${doc} $out/share/paraview/doc/${doc.name}
      cp -r ${examples}/examples $out/share/paraview
      python -m compileall -s $out $out/${vtk-full.vtkPackages.python3Packages.python.sitePackages}
    ''
    + lib.optionalString stdenv.hostPlatform.isLinux ''
      install -Dm644 ../Qt/Components/Resources/Icons/pvIcon.svg $out/share/icons/hicolor/scalable/apps/paraview.svg
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      ln -s ../Applications/paraview.app/Contents/MacOS/paraview $out/bin/paraview
    '';

    meta = {
      description = "3D Data analysis and visualization application";
      homepage = "https://www.paraview.org";
      changelog = "https://www.kitware.com/paraview-${lib.concatStringsSep "-" (lib.versions.splitVersion finalAttrs.version)}-release-notes";
      mainProgram = "paraview";
      license = lib.licenses.bsd3;
      platforms = lib.platforms.unix;
      maintainers = with lib.maintainers; [
        guibert
        qbisi
      ];
    };
  }
)
