{
  lib,
  stdenv,
  fetchFromGitHub,
  clipper,
  cmake,
  cups,
  doxygen,
  gdal,
  ninja,
  proj,
  qt5,
  xcbuild,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "OpenOrienteering-Mapper";
  version = "0.9.6";

  src = fetchFromGitHub {
    owner = "OpenOrienteering";
    repo = "mapper";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JfjQe7t3F/9/ik7b+6UUbsYIcpkSDxHBgnbQEYyDTMI=";
  };

  postPatch = ''
    substituteInPlace packaging/custom_install.cmake.in \
      --replace-fail "fixup_bundle_portable(" "#fixup_bundle_portable("
    substituteInPlace src/CMakeLists.txt --replace-fail plutil echo
  '';

  nativeBuildInputs = [
    cmake
    doxygen
    ninja
    qt5.qttools
    qt5.wrapQtAppsHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    xcbuild # for plutil
  ];

  buildInputs = [
    clipper
    cups
    gdal
    proj
    qt5.qtimageformats
    qt5.qtlocation
    qt5.qtsensors
    zlib
  ];

  cmakeFlags = [
    # Building the manual and bundling licenses fails
    # See https://github.com/NixOS/nixpkgs/issues/85306
    (lib.cmakeBool "LICENSING_PROVIDER" false)
    (lib.cmakeBool "Mapper_MANUAL_QTHELP" false)
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # FindGDAL is broken and always finds /Library/Framework unless this is
    # specified
    (lib.cmakeFeature "GDAL_INCLUDE_DIR" "${gdal}/include")
    (lib.cmakeFeature "GDAL_CONFIG" "${gdal}/bin/gdal-config")
    (lib.cmakeFeature "GDAL_LIBRARY" "${gdal}/lib/libgdal.dylib")
    # Don't bundle libraries
    (lib.cmakeBool "Mapper_PACKAGE_PROJ" false)
    (lib.cmakeBool "Mapper_PACKAGE_QT" false)
    (lib.cmakeBool "Mapper_PACKAGE_ASSISTANT" false)
    (lib.cmakeBool "Mapper_PACKAGE_GDAL" false)
  ];

  postBuild = lib.optionalString stdenv.hostPlatform.isDarwin ''
    chmod +w src/Mapper.app/Contents/Info.plist
    plutil -replace NSHighResolutionCapable -bool true src/Mapper.app/Contents/Info.plist
  '';

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/{Applications,bin}
    mv $out/Mapper.app $out/Applications
    ln -s $out/Applications/Mapper.app/Contents/MacOS/Mapper $out/bin/Mapper
  '';

  meta = {
    homepage = "https://www.openorienteering.org/apps/mapper/";
    description = "Orienteering mapmaking program";
    changelog = "https://github.com/OpenOrienteering/mapper/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      mpickering
      sikmir
    ];
    platforms = with lib.platforms; unix;
    mainProgram = "Mapper";
  };
})
