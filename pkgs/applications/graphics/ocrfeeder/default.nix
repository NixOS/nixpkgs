{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  wrapGAppsHook3,
  intltool,
  itstool,
  libxml2,
  gobject-introspection,
  gtk3,
  goocanvas2,
  gtkspell3,
  isocodes,
  gnome,
  python3,
  tesseract4,
  extraOcrEngines ? [ ], # other supported engines are: ocrad gocr cuneiform
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ocrfeeder";
  version = "0.8.5";

  src = fetchurl {
    url = "mirror://gnome/sources/${finalAttrs.pname}/${lib.versions.majorMinor finalAttrs.version}/${finalAttrs.pname}-${finalAttrs.version}.tar.xz";
    sha256 = "sha256-sD0qWUndguJzTw0uy0FIqupFf4OX6dTFvcd+Mz+8Su0=";
  };

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook3
    intltool
    itstool
    libxml2
    gobject-introspection
  ];

  buildInputs = [
    gtk3
    goocanvas2
    gtkspell3
    isocodes
    (python3.withPackages (
      ps: with ps; [
        pyenchant
        sane
        pillow
        reportlab
        odfpy
        pygobject3
      ]
    ))
  ];
  patches = [
    # Compiles, but doesn't launch without this, see:
    # https://gitlab.gnome.org/GNOME/ocrfeeder/-/issues/83
    ./fix-launch.diff
  ];

  enginesPath = lib.makeBinPath (
    [
      tesseract4
    ]
    ++ extraOcrEngines
  );

  preFixup = ''
    gappsWrapperArgs+=(--prefix PATH : "${finalAttrs.enginesPath}")
    gappsWrapperArgs+=(--set ISO_CODES_DIR "${isocodes}/share/xml/iso-codes")
  '';

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/GNOME/ocrfeeder";
    description = "Complete Optical Character Recognition and Document Analysis and Recognition program";
    maintainers = with maintainers; [ doronbehar ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
})
