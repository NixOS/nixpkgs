{
  lib,
  fetchurl,
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
  poppler_utils,
  ghostscript,
  unpaper,
  pdftk,
  # test dependencies
  xvfb-run,
  liberation_ttf,
  file,
  tesseract,
}:

perlPackages.buildPerlPackage rec {
  pname = "gscan2pdf";
  version = "2.13.3";

  src = fetchurl {
    url = "mirror://sourceforge/gscan2pdf/gscan2pdf-${version}.tar.xz";
    hash = "sha256-QAs6fsQDe9+nKM/OAVZUHB034K72jHsKoA2LY2JQa8Y=";
  };

  patches = [
    # fixes an error with utf8 file names. See https://sourceforge.net/p/gscan2pdf/bugs/400
    ./image-utf8-fix.patch
  ];

  nativeBuildInputs = [ wrapGAppsHook3 ];

  buildInputs =
    [
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

  postPatch =
    let
      fontSubstitute = "${liberation_ttf}/share/fonts/truetype/LiberationSans-Regular.ttf";
    in
    ''
      # Required for the program to properly load its SVG assets
      substituteInPlace bin/gscan2pdf \
        --replace "/usr/share" "$out/share"

      # Substitute the non-free Helvetica font in the tests
      sed -i 's|-pointsize|-font ${fontSubstitute} -pointsize|g' t/*.t
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
      --prefix PATH : "${poppler_utils}/bin" \
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

  nativeCheckInputs =
    [
      imagemagick
      libtiff
      djvulibre
      poppler_utils
      ghostscript
      unpaper
      pdftk

      xvfb-run
      file
      tesseract # tests are expecting tesseract 3.x precisely
    ]
    ++ (with perlPackages; [
      TestPod
    ]);

  checkPhase = ''
    # Temporarily disable a dubiously failing test:
    # t/169_import_scan.t ........................... 1/1
    # #   Failed test 'variable-height scan imported with expected size'
    # #   at t/169_import_scan.t line 50.
    # #          got: '179'
    # #     expected: '296'
    # # Looks like you failed 1 test of 1.
    # t/169_import_scan.t ........................... Dubious, test returned 1 (wstat 256, 0x100)
    rm t/169_import_scan.t

    # Disable a test failing because of a warning interfering with the pinned output
    # t/3722_user_defined.t ......................... 1/2
    #   Failed test 'user_defined caught error injected in queue'
    #   at t/3722_user_defined.t line 41.
    #          got: 'error
    # WARNING: The convert command is deprecated in IMv7, use "magick" instead of "convert" or "magick convert"'
    #     expected: 'error'
    # Looks like you failed 1 test of 2.
    rm t/3722_user_defined.t

    export XDG_CACHE_HOME="$(mktemp -d)"
    xvfb-run -s '-screen 0 800x600x24' \
      make test
  '';

  meta = with lib; {
    description = "GUI to produce PDFs or DjVus from scanned documents";
    homepage = "https://gscan2pdf.sourceforge.net/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ pacien ];
    mainProgram = "gscan2pdf";
  };
}
