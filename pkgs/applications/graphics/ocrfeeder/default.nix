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
  version = "0.8.5";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-sD0qWUndguJzTw0uy0FIqupFf4OX6dTFvcd+Mz+8Su0=";
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
  patches = [
    # Compiles, but doesn't launch without this, see:
    # https://gitlab.gnome.org/GNOME/ocrfeeder/-/issues/83
    ./fix-launch.diff
  ];

  enginesPath = lib.makeBinPath ([
    tesseract4
  ] ++ extraOcrEngines);

  preFixup = ''
    gappsWrapperArgs+=(--prefix PATH : "${enginesPath}")
    gappsWrapperArgs+=(--set ISO_CODES_DIR "${isocodes}/share/xml/iso-codes")
  '';

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Apps/OCRFeeder";
    description = "Complete Optical Character Recognition and Document Analysis and Recognition program";
    maintainers = with maintainers; [ doronbehar ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
