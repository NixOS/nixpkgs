{ stdenv, fetchurl, perlPackages, wrapGAppsHook,
  # libs
  librsvg, sane-backends, sane-frontends,
  # runtime dependencies
  imagemagick, libtiff, djvulibre, poppler_utils, ghostscript, unpaper, pdftk,
  # test dependencies
  xvfb_run, liberation_ttf, file, tesseract }:

with stdenv.lib;

perlPackages.buildPerlPackage rec {
  pname = "gscan2pdf";
  version = "2.6.3";

  src = fetchurl {
    url = "mirror://sourceforge/gscan2pdf/${version}/${pname}-${version}.tar.xz";
    sha256 = "1chmk51xwylnjrgc6hw23x7g7cpwzgwmjc49fcah7pkd3dk1cvvr";
  };

  nativeBuildInputs = [ wrapGAppsHook ];

  buildInputs =
    [ librsvg sane-backends sane-frontends ] ++
    (with perlPackages; [
      Gtk3
      Gtk3SimpleList
      Cairo
      CairoGObject
      Glib
      GlibObjectIntrospection
      GooCanvas2
      LocaleGettext
      PDFAPI2
      ImageSane
      SetIntSpan
      PerlMagick
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

  checkInputs = [
    imagemagick
    libtiff
    djvulibre
    poppler_utils
    ghostscript
    unpaper
    pdftk

    xvfb_run
    file
    tesseract # tests are expecting tesseract 3.x precisely
  ];

  checkPhase = ''
    xvfb-run -s '-screen 0 800x600x24' \
      make test
  '';

  meta = {
    description = "A GUI to produce PDFs or DjVus from scanned documents";
    homepage = http://gscan2pdf.sourceforge.net/;
    license = licenses.gpl3;
    maintainers = with maintainers; [ pacien ];
  };
}
