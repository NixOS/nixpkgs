{
  lib,
  stdenv,
  fetchurl,
  cmake,
  ninja,
  qt6Packages,
  protobuf,
  vtk-full,
  testers,
}:
let
  paraviewFilesUrl = "https://www.paraview.org/files";
  doc = fetchurl {
    url = "${paraviewFilesUrl}/v6.0/ParaViewGettingStarted-6.0.1.pdf";
    name = "GettingStarted.pdf";
    hash = "sha256-2ghvb0UXa0Z/YGWzCchB1NKowRdlC/ZQCI3y0tZUdbo=";
  };
  examples = fetchurl {
    # see https://gitlab.kitware.com/paraview/paraview-superbuild/-/blob/v6.0.0/versions.cmake?ref_type=tags#L21
    url = "${paraviewFilesUrl}/data/ParaViewTutorialData-20220629.tar.gz";
    hash = "sha256-OCLvWlwhBL9R981zXWZueMyXVeiqbxsmUYcwIu1doQ4=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "paraview";
  version = "6.0.1";

  src = fetchurl {
    url = "${paraviewFilesUrl}/v${lib.versions.majorMinor finalAttrs.version}/ParaView-v${finalAttrs.version}.tar.xz";
    hash = "sha256-XlasevXpJbPP0/q4JHCTPLq8fo/ah+FK9k+ZXWBk6wY=";
  };

  postPatch = ''
    # When building paraview with external vtk, we can not infer resource_dir
    # from the path of vtk's libraries. Thus hardcoding the resource_dir.
    # See https://gitlab.kitware.com/paraview/paraview/-/issues/23043.
    substituteInPlace Remoting/Core/vtkPVFileInformation.cxx \
      --replace-fail "return resource_dir;" "return \"$out/share/paraview\";"

    # fix build against qt-6.10.1
    substituteInPlace Qt/Core/{pqFlatTreeViewEventTranslator,pqQVTKWidgetEventTranslator}.cxx \
      ThirdParty/QtTesting/vtkqttesting/{pqAbstractItemViewEventTranslator,pqBasicWidgetEventTranslator}.cxx \
      --replace-fail "mouseEvent->buttons()" "static_cast<int>(mouseEvent->buttons())" \
      --replace-fail "mouseEvent->modifiers()" "static_cast<int>(mouseEvent->modifiers())"
  '';

  nativeBuildInputs = [
    cmake
    ninja
    qt6Packages.wrapQtAppsHook
    vtk-full.vtkPackages.python3Packages.pythonRecompileBytecodeHook
  ];

  # propagation required by paraview-config.cmake
  propagatedBuildInputs = [
    qt6Packages.qttools
    qt6Packages.qt5compat
    protobuf
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
    mkdir -p $out/share/paraview/examples
    tar --strip-components=1 -xzf ${examples} -C $out/share/paraview/examples
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    install -Dm644 ../Qt/Components/Resources/Icons/pvIcon.svg $out/share/icons/hicolor/scalable/apps/paraview.svg
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    ln -s ../Applications/paraview.app/Contents/MacOS/paraview $out/bin/paraview
  '';

  passthru.tests = {
    cmake-config = testers.hasCmakeConfigModules {
      moduleNames = [ "ParaView" ];

      package = finalAttrs.finalPackage;

      nativeBuildInputs = [
        qt6Packages.wrapQtAppsHook
      ];
    };
  };

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
})
