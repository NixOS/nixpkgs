{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  pkg-config,
  which,
  qmake,
  qttools,
  wrapQtAppsHook,
  libusb1,
  shapelib,
  zlib,
  withGUI ? false,
  qtserialport,
  withMapPreview ? (!stdenv.isDarwin),
  qtwebengine,
  withDoc ? false,
  docbook_xml_dtd_45,
  docbook_xsl,
  expat,
  fop,
  libxml2,
  libxslt,
  perl,
}:

stdenv.mkDerivation rec {
  pname = "gpsbabel";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "gpsbabel";
    repo = "gpsbabel";
    rev = "gpsbabel_${lib.replaceStrings [ "." ] [ "_" ] version}";
    sha256 = "sha256-0w8LsO+HwqZF8SQmwd8bCKma9PCM0hAzXhzWR4DgAHs=";
  };

  patches = map fetchurl (import ./debian-patches.nix);

  postPatch =
    ''
      patchShebangs testo
    ''
    + lib.optionalString withDoc ''
      substituteInPlace gbversion.h.qmake.in \
        --replace /usr/share/doc $doc/share/doc

      substituteInPlace testo.d/serialization.test \
        --replace /usr/share/doc $doc/share/doc

      substituteInPlace xmldoc/gpsbabel_man.xml \
        --replace /usr/share/doc $doc/share/doc
    '';

  outputs = [ "out" ] ++ lib.optional withDoc "doc";

  nativeBuildInputs =
    [
      pkg-config
      qmake
    ]
    ++ lib.optionals withGUI [
      qttools
      wrapQtAppsHook
    ]
    ++ lib.optionals withDoc [
      docbook_xml_dtd_45
      docbook_xsl
      expat
      fop
      libxml2
      libxslt
      perl
    ];

  buildInputs =
    [
      libusb1
      shapelib
      zlib
    ]
    ++ lib.optional withGUI qtserialport
    ++ lib.optional (withGUI && withMapPreview) qtwebengine;

  nativeCheckInputs = [
    libxml2
    which
  ];

  preConfigure = lib.optionalString withGUI ''
    lrelease gui/*.ts gui/coretool/*.ts
  '';

  qmakeFlags =
    [
      "WITH_LIBUSB=pkgconfig"
      "WITH_SHAPELIB=pkgconfig"
      "WITH_ZLIB=pkgconfig"
    ]
    ++ lib.optionals (withGUI && !withMapPreview) [
      "CONFIG+=disable-mappreview"
    ];

  makeFlags =
    lib.optional withGUI "gui"
    ++ lib.optionals withDoc [
      "gpsbabel.pdf"
      "gpsbabel.html"
      "gpsbabel.org"
    ];

  # Floating point behavior on i686 causes nmea.test failures. Preventing
  # extended precision fixes this problem.
  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isi686 "-ffloat-store";

  doCheck = true;

  dontWrapQtApps = true;

  installPhase =
    ''
      install -Dm755 gpsbabel -t $out/bin
    ''
    + lib.optionalString withGUI (
      if stdenv.isDarwin then
        ''
          mkdir -p $out/Applications
          mv gui/GPSBabelFE.app $out/Applications
          install -Dm644 gui/*.qm gui/coretool/*.qm -t $out/Applications/GPSBabelFE.app/Contents/Resources/translations
          ln -s $out/bin/gpsbabel $out/Applications/GPSBabelFE.app/Contents/MacOS
        ''
      else
        ''
          install -Dm755 gui/objects/gpsbabelfe -t $out/bin
          install -Dm644 gui/gpsbabel.desktop -t $out/share/application
          install -Dm644 gui/images/appicon.png $out/share/icons/hicolor/512x512/apps/gpsbabel.png
          install -Dm644 gui/*.qm gui/coretool/*.qm -t $out/share/gpsbabel/translations
        ''
    )
    + lib.optionalString withDoc ''
      install -Dm655 gpsbabel.{html,pdf} -t $doc/share/doc/gpsbabel
      cp -r html $doc/share/doc/gpsbabel
    '';

  postFixup = lib.optionalString withGUI (
    if stdenv.isDarwin then
      ''
        wrapQtApp "$out/Applications/GPSBabelFE.app/Contents/MacOS/GPSBabelFE"
      ''
    else
      ''
        wrapQtApp "$out/bin/gpsbabelfe"
      ''
  );

  meta = with lib; {
    description = "Convert, upload and download data from GPS and Map programs";
    longDescription = ''
      GPSBabel converts waypoints, tracks, and routes between popular
      GPS receivers and mapping programs.  It also has powerful
      manipulation tools for such data.

      By flattening the Tower of Babel that the authors of various
      programs for manipulating GPS data have imposed upon us, it
      returns to us the ability to freely move our own waypoint data
      between the programs and hardware we choose to use.

      It contains extensive data manipulation abilities making it a
      convenient for server-side processing or as the backend for
      other tools.

      It does not convert, transfer, send, or manipulate maps.  We
      process data that may (or may not be) placed on a map, such as
      waypoints, tracks, and routes.
    '';
    homepage = "https://www.gpsbabel.org/";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ sikmir ];
    mainProgram = "gpsbabel";
  };
}
