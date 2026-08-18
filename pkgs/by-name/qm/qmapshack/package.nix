{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qt6,
  qt6Packages,
  alglib,
  gdal,
  proj,
  routino,
}:

let
  qtwebengine =
    if stdenv.hostPlatform.isDarwin then
      qt6.qtwebengine.overrideAttrs (oldAttrs: {
        # Remove when these Darwin fixes are included in qtwebengine:
        # https://github.com/NixOS/nixpkgs/pull/515997
        # https://github.com/NixOS/nixpkgs/pull/520445
        # https://github.com/NixOS/nixpkgs/pull/547302
        postPatch = oldAttrs.postPatch + ''
          substituteInPlace cmake/QtToolchainHelpers.cmake \
            --replace-fail 'clang_base_path="''${QWELibClang_BASE_PATH}"' 'clang_base_path="${stdenv.cc}"'
          substituteInPlace cmake/QtConfigureHelpers.cmake \
            --replace-fail 'message(STATUS "Checking for Metal Toolchain")' 'message(STATUS "Checking for Metal Toolchain")
              set(TEST_metal_toolchain TRUE PARENT_SCOPE)
              return()'
          substituteInPlace src/core/configure/BUILD.root.gn.in src/pdf/configure/BUILD.root.gn.in \
            --replace-fail 'lflags_remove = "(--sysroot=)(\\.\\./.*\\S*?)" # ignore sysroot with realative path' \
              'lflags_remove = "(--sysroot=|-isysroot )\\.\\./\\S+" # ignore sysroot with relative path'
          substituteInPlace src/core/configure/BUILD.root.gn.in \
            --replace-fail '  shared_library("convert_dict") {
              rsp_types = [ "objects", "archives", "libs", "ldir", "lflags" ]' \
              '  shared_library("convert_dict") {
              rsp_types = [ "objects", "archives", "libs", "ldir", "lflags" ]
              lflags_remove = "(--sysroot=|-isysroot )\\.\\./\\S+" # ignore sysroot with relative path'
        '';
        cmakeFlags = oldAttrs.cmakeFlags ++ [ "-DCMAKE_OSX_DEPLOYMENT_TARGET=12.0" ];
      })
    else
      qt6.qtwebengine;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "qmapshack";
  version = "1.20.3";

  src = fetchFromGitHub {
    owner = "Maproom";
    repo = "qmapshack";
    tag = "V_${finalAttrs.version}";
    hash = "sha256-U9sOIcQKE9v5vXsfvloLbfxtrCNliJEYnbc1mlwk9bo=";
  };

  nativeBuildInputs = [
    cmake
    qt6.qttools
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    alglib
    gdal
    proj
    routino
    qtwebengine
    qt6Packages.quazip
  ];

  cmakeFlags = [
    (lib.cmakeFeature "ALGLIB_INCLUDE_DIRS" "${alglib}/include/alglib")
    (lib.cmakeFeature "ALGLIB_LIBRARIES" "alglib3")
    (lib.cmakeFeature "ROUTINO_XML_PATH" "${routino}/share/routino")
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    (lib.cmakeFeature "QT_DEV_PATH" "${qt6.qtbase.dev}")
    (lib.cmakeFeature "ROUTINO_DEV_PATH" "${routino}")
    (lib.cmakeFeature "QuaZip-Qt6_DIR" "${qt6Packages.quazip.dev}/lib/cmake/QuaZip-Qt6-${qt6Packages.quazip.version}")
    (lib.cmakeFeature "PROJ_DEV_PATH" "${proj}")
    (lib.cmakeFeature "GDAL_DEV_PATH" "${gdal}")
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    for app in QMapShack QMapTool; do
      contents="$out/Applications/$app.app/Contents"
      mkdir -p "$contents/MacOS" "$contents/Resources/help" "$contents/Resources/translations"
      ln -s ${gdal}/share/gdal "$contents/Resources/gdal"
      ln -s ${gdal}/lib/gdalplugins "$contents/Resources/gdalplugins"
      ln -s ${proj}/share/proj "$contents/Resources/proj"
      ln -s ${routino}/share/routino "$contents/Resources/routino"
      ln -s "$out/bin" "$contents/Tools"

      cp "$src"/MacOSX/resources/*.qss "$contents/Resources/"
      cp "$src"/src/qmapshack/doc/QMSHelp.qch "$src"/src/qmapshack/doc/QMSHelp.qhc "$contents/Resources/help/"
      cp "$src"/src/qmaptool/doc/QMTHelp.qch "$src"/src/qmaptool/doc/QMTHelp.qhc "$contents/Resources/help/"
      cp src/qmapshack/*.qm src/qmaptool/*.qm src/qmt_rgb2pct/*.qm "$contents/Resources/translations/"
      cp ${qt6.qttranslations}/translations/qtbase_*.qm "$contents/Resources/translations/"
      install -Dm444 "$src/MacOSX/resources/$app.icns" "$contents/Resources/$app.icns"
      substitute "$src/MacOSX/resources/Info.plist" "$contents/Info.plist" \
        --replace-fail QMapShack "$app" \
        --replace-fail APP_VERSION ${finalAttrs.version} \
        --replace-fail BUNDLE_VERSION ${finalAttrs.version} \
        --replace-fail PACKAGES_PATH "$out"
    done

    mv "$out/bin/qmapshack" "$out/Applications/QMapShack.app/Contents/MacOS/QMapShack"
    mv "$out/bin/qmaptool" "$out/Applications/QMapTool.app/Contents/MacOS/QMapTool"
    ln -s "$out/Applications/QMapShack.app/Contents/MacOS/QMapShack" "$out/bin/qmapshack"
    ln -s "$out/Applications/QMapTool.app/Contents/MacOS/QMapTool" "$out/bin/qmaptool"
  '';

  qtWrapperArgs = [
    "--suffix PATH : ${
      lib.makeBinPath [
        gdal
        routino
      ]
    }"
  ];

  meta = {
    description = "Consumer grade GIS software";
    homepage = "https://github.com/Maproom/qmapshack";
    changelog = "https://github.com/Maproom/qmapshack/blob/V_${finalAttrs.version}/changelog.txt";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      dotlambda
      sikmir
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
