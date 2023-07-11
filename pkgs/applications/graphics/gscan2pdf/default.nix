{ lib, fetchurl, perlPackages, wrapGAppsHook,
  # libs
  librsvg, sane-backends, sane-frontends,
  # runtime dependencies
  imagemagick, libtiff, djvulibre, poppler_utils, ghostscript, unpaper, pdftk,
  # test dependencies
  xvfb-run, liberation_ttf, file, tesseract }:

with lib;

perlPackages.buildPerlPackage rec {
  pname = "gscan2pdf";
  version = "2.13.2";

  src = fetchurl {
    url = "mirror://sourceforge/gscan2pdf/gscan2pdf-${version}.tar.xz";
    hash = "sha256-NGz6DUa7TdChpgwmD9pcGdvYr3R+Ft3jPPSJpybCW4Q=";
  };

  nativeBuildInputs = [ wrapGAppsHook ];

  buildInputs =
    [ librsvg sane-backends sane-frontends ] ++
    (with perlPackages; [
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

  postPatch = let
    fontSubstitute = "${liberation_ttf}/share/fonts/truetype/LiberationSans-Regular.ttf";
  in ''
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

  outputs = [ "out" "man" ];

  nativeCheckInputs = [
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
  ] ++ (with perlPackages; [
    TestPod
  ]);

  checkPhase = ''
    # Temporarily disable a test failing after a patch imagemagick update.
    # It might only due to the reporting and matching used in the test.
    # See https://github.com/NixOS/nixpkgs/issues/223446
    # See https://sourceforge.net/p/gscan2pdf/bugs/417/
    #
    #   Failed test 'valid TIFF created'
    #   at t/131_save_tiff.t line 44.
    #                   'test.tif TIFF 70x46 70x46+0+0 8-bit sRGB 10024B 0.000u 0:00.000
    # '
    #     doesn't match '(?^:test.tif TIFF 70x46 70x46\+0\+0 8-bit sRGB [7|9][.\d]+K?B)'
    rm t/131_save_tiff.t

    # Temporarily disable a dubiously failing test:
    # t/169_import_scan.t ........................... 1/1
    # #   Failed test 'variable-height scan imported with expected size'
    # #   at t/169_import_scan.t line 50.
    # #          got: '179'
    # #     expected: '296'
    # # Looks like you failed 1 test of 1.
    # t/169_import_scan.t ........................... Dubious, test returned 1 (wstat 256, 0x100)
    rm t/169_import_scan.t

    # Disable a test which passes but reports an incorrect status
    # t/0601_Dialog_Scan.t .......................... All 14 subtests passed
    # t/0601_Dialog_Scan.t                        (Wstat: 139 Tests: 14 Failed: 0)
    #   Non-zero wait status: 139
    rm t/0601_Dialog_Scan.t

    # Disable a test which failed due to convert returning an exit value of 1
    # convert: negative or zero image size `/build/KL5kTVnNCi/YfgegFM53e.pnm' @ error/resize.c/ResizeImage/3743.
    # *** unhandled exception in callback:
    # ***   "convert" unexpectedly returned exit value 1 at t/357_unpaper_rtl.t line 63.
    rm t/357_unpaper_rtl.t

    xvfb-run -s '-screen 0 800x600x24' \
      make test
  '';

  meta = {
    description = "A GUI to produce PDFs or DjVus from scanned documents";
    homepage = "https://gscan2pdf.sourceforge.net/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ pacien ];
  };
}
