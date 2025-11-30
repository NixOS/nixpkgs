{
  lib,
  stdenv,
  fetchurl,
  bison,
  cdrtools,
  docbook_xml_dtd_412,
  docbook-xsl-nons,
  dvdauthor,
  dvdplusrwtools,
  ffmpeg_7,
  flex,
  fontconfig,
  gettext,
  glib,
  gobject-introspection,
  libexif,
  libjpeg,
  pkg-config,
  wrapGAppsHook3,
  wxGTK32,
  wxSVG,
  xine-ui,
  xmlto,
  zip,

  dvdisasterSupport ? true,
  dvdisaster ? null,
  udevSupport ? true,
  udev ? null,
  dbusSupport ? true,
  dbus ? null,
}:

let
  inherit (lib) optionals makeBinPath;
in
stdenv.mkDerivation rec {
  pname = "dvdstyler";
  version = "3.3b4";

  src = fetchurl {
    url = "mirror://sourceforge/project/dvdstyler/dvdstyler-devel/${version}/DVDStyler-${version}.tar.bz2";
    hash = "sha256-JCaKcE7jkTxT57KKePs8gmgQedoOcP5NEQ2FwIDS2Ho=";
  };

  nativeBuildInputs = [
    bison
    docbook_xml_dtd_412
    docbook-xsl-nons
    flex
    gettext
    gobject-introspection
    pkg-config
    wrapGAppsHook3
    xmlto
    zip
  ];
  buildInputs = [
    cdrtools
    dvdauthor
    dvdplusrwtools
    ffmpeg_7
    fontconfig
    glib
    libexif
    libjpeg
    wxSVG
    wxGTK32
    xine-ui
  ]
  ++ optionals dvdisasterSupport [ dvdisaster ]
  ++ optionals udevSupport [ udev ]
  ++ optionals dbusSupport [ dbus ];

  enableParallelBuilding = true;

  preFixup =
    let
      binPath = makeBinPath (
        [
          cdrtools
          dvdauthor
          dvdplusrwtools
        ]
        ++ optionals dvdisasterSupport [ dvdisaster ]
      );
    in
    ''
      gappsWrapperArgs+=(
        --prefix PATH : "${binPath}"
      )
    '';

  meta = with lib; {
    homepage = "https://www.dvdstyler.org/";
    description = "DVD authoring software";
    longDescription = ''
      DVDStyler is a cross-platform free DVD authoring application for the
      creation of professional-looking DVDs. It allows not only burning of video
      files on DVD that can be played practically on any standalone DVD player,
      but also creation of individually designed DVD menus. It is Open Source
      Software and is completely free.

      Some of its features include:

      - create and burn DVD video with interactive menus
      - design your own DVD menu or select one from the list of ready to use menu
        templates
      - create photo slideshow
      - add multiple subtitle and audio tracks
      - support of AVI, MOV, MP4, MPEG, OGG, WMV and other file formats
      - support of MPEG-2, MPEG-4, DivX, Xvid, MP2, MP3, AC-3 and other audio and
        video formats
      - support of multi-core processor
      - use MPEG and VOB files without reencoding
      - put files with different audio/video format on one DVD (support of
        titleset)
      - user-friendly interface with support of drag & drop
      - flexible menu creation on the basis of scalable vector graphic
      - import of image file for background
      - place buttons, text, images and other graphic objects anywhere on the menu
        screen
      - change the font/color and other parameters of buttons and graphic objects
      - scale any button or graphic object
      - copy any menu object or whole menu
      - customize navigation using DVD scripting
    '';
    license = licenses.gpl2Plus;
    maintainers = [ ];
    platforms = with platforms; linux;
    mainProgram = "dvdstyler";
  };
}
