{
  lib,
  stdenv,
  cmake,
  copyDesktopItems,
  fetchFromGitHub,
  makeDesktopItem,
  pkg-config,
  libpq,
  cups,
  libxml2,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pgmodeler";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "nullptrlabs";
    repo = "pgmodeler";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-4xXtUnvW8mhUYPsICrXDIMM9+tHdq7qdRdsI7Irjw2E=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6.qttools
    qt6.wrapQtAppsHook
    copyDesktopItems
  ];

  postPatch = ''
    patchShebangs getbuildnum.sh
    substituteInPlace BuildConfs.cmake \
      --replace-fail 'set(CMAKE_C_COMPILER /usr/bin/clang)' "" \
      --replace-fail 'set(CMAKE_CXX_COMPILER /usr/bin/clang++)' ""
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace DefaultPaths.cmake \
      --replace-fail 'set(PGSQL_INC /Library/PostgreSQL/17/include)' "" \
      --replace-fail 'set(PGSQL_LIBS /Library/PostgreSQL/17/lib/libpq.dylib)' "" \
      --replace-fail 'set(XML2_INC ''${CMAKE_OSX_SYSROOT}/usr/include/libxml2)' "" \
      --replace-fail 'set(XML2_LIBS ''${CMAKE_OSX_SYSROOT}/usr/lib/libxml2.tbd)' ""
  '';

  cmakeFlags = [
    "-DPGM_PREFIX=${placeholder "out"}${lib.optionalString stdenv.hostPlatform.isDarwin "/Applications/pgModeler.app/Contents"}"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "-DPGSQL_INC=${lib.getDev libpq}/include"
    "-DPGSQL_LIBS=${lib.getLib libpq}/lib/libpq.dylib"
    "-DXML2_INC=${libxml2.dev}/include/libxml2"
    "-DXML2_LIBS=${libxml2.out}/lib/libxml2.dylib"
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtsvg
    libpq
    libxml2
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ qt6.qtwayland ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ cups ];

  desktopItems = [
    (makeDesktopItem {
      name = "pgModeler";
      exec = "pgmodeler";
      icon = "pgmodeler";
      desktopName = "PgModeler";
      genericName = "PgModeler";
      comment = finalAttrs.meta.description;
      categories = [ "Development" ];
      startupWMClass = "pgmodeler";
    })
  ];

  postInstall = ''
    install -Dm444 ${finalAttrs.src}/apps/pgmodeler/res/pgmodeler.ico $out/share/icons/hicolor/256x256/apps/pgmodeler.ico
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/bin
    for item in pgmodeler pgmodeler-{cli,se,ch}
    do
      ln -s $out/Applications/pgModeler.app/Contents/MacOS/$item $out/bin
    done
  '';

  dontWrapQtApps = stdenv.hostPlatform.isDarwin;

  meta = {
    description = "Database modeling tool for PostgreSQL";
    homepage = "https://pgmodeler.io/";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.esclear ];
    platforms = lib.platforms.unix;
  };
})
