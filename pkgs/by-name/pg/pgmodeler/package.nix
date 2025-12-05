{
  lib,
  stdenv,
  copyDesktopItems,
  fetchFromGitHub,
  makeDesktopItem,
  pkg-config,
  libpq,
  cups,
  libxml2,
  qt6,
}:

stdenv.mkDerivation rec {
  pname = "pgmodeler";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "pgmodeler";
    repo = "pgmodeler";
    rev = "v${version}";
    sha256 = "sha256-gDhH6b+8zFIsosdecUUkwAQMP1HME4EbJZsFyTzvGcE=";
  };

  nativeBuildInputs = [
    pkg-config
    qt6.qmake
    qt6.wrapQtAppsHook
    copyDesktopItems
  ];

  qmakeFlags = [
    "pgmodeler.pro"
    "CONFIG+=release"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "PGSQL_INC=${lib.getDev libpq}/include"
    "PGSQL_LIB=${lib.getLib libpq}/lib/libpq.dylib"
    "XML_INC=${libxml2.dev}/include/libxml2"
    "XML_LIB=${libxml2.out}/lib/libxml2.dylib"
    "PREFIX=${placeholder "out"}/Applications/pgModeler.app/Contents"
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtsvg
    libpq
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ qt6.qtwayland ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    cups
    libxml2
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "pgModeler";
      exec = "pgmodeler";
      icon = "pgmodeler";
      desktopName = "PgModeler";
      genericName = "PgModeler";
      comment = meta.description;
      categories = [ "Development" ];
      startupWMClass = "pgmodeler";
    })
  ];

  postInstall = ''
    install -Dm444 apps/pgmodeler/res/windows_ico.ico $out/share/icons/hicolor/256x256/apps/pgmodeler.ico
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/bin
    for item in pgmodeler pgmodeler-{cli,se,ch}
    do
      ln -s $out/Applications/pgModeler.app/Contents/MacOS/$item $out/bin
    done
  '';

  dontWrapQtApps = stdenv.hostPlatform.isDarwin;

  meta = with lib; {
    description = "Database modeling tool for PostgreSQL";
    homepage = "https://pgmodeler.io/";
    license = licenses.gpl3;
    maintainers = [ maintainers.esclear ];
    platforms = platforms.unix;
  };
}
