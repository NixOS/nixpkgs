{
  lib,
  fetchurl,
  fetchpatch,
  perlPackages,
  wrapGAppsHook3,
  # libs
  librsvg,
  sane-backends,
  sane-frontends,
  # runtime dependencies
  imagemagick,
  libtiff,
  djvulibre,
  poppler-utils,
  ghostscript,
  unpaper,
  pdftk,
  # test dependencies
  xvfb-run,
  file,
  tesseract,
}:

perlPackages.buildPerlPackage rec {
  pname = "gscan2pdf";
  version = "2.13.5";

  src = fetchurl {
    url = "mirror://sourceforge/gscan2pdf/gscan2pdf-${version}.tar.xz";
    hash = "sha256-DUME9nI9B2+Gj+sBPj176SXfuxDc3CMXfby/Zga31fo=";
  };

  patches = [
    # fixes an error with utf8 file names. See https://sourceforge.net/p/gscan2pdf/bugs/400
    ./image-utf8-fix.patch
  ];

  nativeBuildInputs = [ wrapGAppsHook3 ];

  buildInputs = [
    librsvg
    sane-backends
    sane-frontends
  ]
  ++ (with perlPackages; [
    Gtk3
    Gtk3ImageView
    Gtk3SimpleList
    Cairo
    CairoGObject
    Glib
    GlibObjectIntrospection
    GooCanvas2
    GraphicsTIFF
    IPCSystemSimple
    LocaleCodes
    LocaleGettext
    PDFBuilder
    ImagePNGLibpng
    ImageSane
    SetIntSpan
    ImageMagick
    ConfigGeneral
    ListMoreUtils
    HTMLParser
    ProcProcessTable
    LogLog4perl
    TryTiny
    DataUUID
    DateCalc
    IOString
    FilesysDf
    SubOverride
  ]);

  # Required for the program to properly load its SVG assets
  postPatch = ''
    substituteInPlace bin/gscan2pdf \
      --replace-fail "/usr/share" "$out/share"
  '';

  postInstall = ''
    # Remove impurity
    find $out -type f -name "*.pod" -delete

    # Add runtime dependencies
    wrapProgram "$out/bin/gscan2pdf" \
      --prefix PATH : "${sane-backends}/bin" \
      --prefix PATH : "${imagemagick}/bin" \
      --prefix PATH : "${libtiff}/bin" \
      --prefix PATH : "${djvulibre}/bin" \
      --prefix PATH : "${poppler-utils}/bin" \
      --prefix PATH : "${ghostscript}/bin" \
      --prefix PATH : "${unpaper}/bin" \
      --prefix PATH : "${pdftk}/bin"
  '';

  enableParallelBuilding = true;

  installTargets = [ "install" ];

  outputs = [
    "out"
    "man"
  ];

  nativeCheckInputs = [
    imagemagick
    libtiff
    djvulibre
    poppler-utils
    ghostscript
    unpaper
    pdftk

    xvfb-run
    file
    tesseract
  ]
  ++ (with perlPackages; [
    TestPod
  ]);

  checkPhase = ''
    export XDG_CACHE_HOME="$(mktemp -d)"
    xvfb-run -s '-screen 0 800x600x24' \
      make test
  '';

  meta = with lib; {
    description = "GUI to produce PDFs or DjVus from scanned documents";
    homepage = "https://gscan2pdf.sourceforge.net/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ euxane ];
    mainProgram = "gscan2pdf";
  };
}
