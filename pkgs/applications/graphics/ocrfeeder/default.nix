{ lib, stdenv
, fetchurl
, pkg-config
, gtk3
, gtkspell3
, isocodes
, goocanvas2
, intltool
, itstool
, libxml2
, gnome
, python3
, gobject-introspection
, wrapGAppsHook
, tesseract4
, extraOcrEngines ? [] # other supported engines are: ocrad gocr cuneiform
}:

stdenv.mkDerivation rec {
  pname = "ocrfeeder";
  version = "0.8.3";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "12f5gnq92ffnd5zaj04df7jrnsdz1zn4zcgpbf5p9qnd21i2y529";
  };

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook
    intltool
    itstool
    libxml2
  ];

  buildInputs = [
    gtk3
    gobject-introspection
    goocanvas2
    gtkspell3
    isocodes
    (python3.withPackages(ps: with ps; [
      pyenchant
      sane
      pillow
      reportlab
      odfpy
      pygobject3
    ]))
  ];

  # https://gitlab.gnome.org/GNOME/ocrfeeder/-/issues/22
  postConfigure = ''
    substituteInPlace src/ocrfeeder/util/constants.py \
      --replace /usr/share/xml/iso-codes ${isocodes}/share/xml/iso-codes
  '';

  enginesPath = lib.makeBinPath ([
    tesseract4
  ] ++ extraOcrEngines);

  preFixup = ''
    gappsWrapperArgs+=(--prefix PATH : "${enginesPath}")
  '';

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Apps/OCRFeeder";
    description = "Complete Optical Character Recognition and Document Analysis and Recognition program";
    maintainers = with maintainers; [ doronbehar ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
