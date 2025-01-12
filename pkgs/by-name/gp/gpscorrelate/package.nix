{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  exiv2,
  libxml2,
  gtk3,
  libxslt,
  docbook_xsl,
  docbook_xml_dtd_42,
  desktop-file-utils,
  wrapGAppsHook3,
  desktopToDarwinBundle,
}:

stdenv.mkDerivation rec {
  pname = "gpscorrelate";
  version = "2.2";

  src = fetchFromGitHub {
    owner = "dfandrich";
    repo = "gpscorrelate";
    rev = version;
    hash = "sha256-H1kqOzL79/Y1kHVEQ5y9JRWTDCBMbtEPo75drm8+7Qo=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    docbook_xml_dtd_42
    docbook_xsl
    libxslt
    pkg-config
    wrapGAppsHook3
  ] ++ lib.optional stdenv.hostPlatform.isDarwin desktopToDarwinBundle;

  buildInputs = [
    exiv2
    gtk3
    libxml2
  ];

  makeFlags = [
    "prefix=${placeholder "out"}"
    "CC=${stdenv.cc.targetPrefix}cc"
    "CXX=${stdenv.cc.targetPrefix}c++"
    "CFLAGS=-DENABLE_NLS"
  ];

  doCheck = true;

  installTargets = [
    "install"
    "install-po"
    "install-desktop-file"
  ];

  meta = with lib; {
    description = "GPS photo correlation tool, to add EXIF geotags";

    longDescription = ''
      Digital cameras are cool.  So is GPS.  And, EXIF tags are really
      cool too.

      What happens when you merge the three?  You end up with a set of
      photos taken with a digital camera that are "stamped" with the
      location at which they were taken.

      The EXIF standard defines a number of tags that are for use with GPS.

      A variety of programs exist around the place to match GPS data
      with digital camera photos, but most of them are Windows or
      MacOS only.  Which doesn't really suit me that much. Also, each
      one takes the GPS data in a different format.
    '';

    license = licenses.gpl2Plus;
    homepage = "https://dfandrich.github.io/gpscorrelate/";
    changelog = "https://github.com/dfandrich/gpscorrelate/releases/tag/${src.rev}";
    platforms = platforms.unix;
    maintainers = with maintainers; [ sikmir ];
  };
}
