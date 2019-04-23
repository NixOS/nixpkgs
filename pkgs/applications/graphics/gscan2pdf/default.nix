{ stdenv, fetchurl, perlPackages, makeWrapper, wrapGAppsHook,
  librsvg, sane-backends, sane-frontends,
  imagemagick, libtiff, djvulibre, poppler_utils, ghostscript, unpaper,
  xvfb_run, hicolor-icon-theme, liberation_ttf, file, pdftk }:

with stdenv.lib;

perlPackages.buildPerlPackage rec {
  name = "gscan2pdf-${version}";
  version = "2.3.0";

  src = fetchurl {
    url = "mirror://sourceforge/gscan2pdf/${version}/${name}.tar.xz";
    sha256 = "0mcsmly0j9pmyzh6py8r6sfa30hc6gv300hqq3dxj4hv653vhkk9";
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
      Log4Perl
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
      --prefix PATH : "${unpaper}/bin"
  '';

  enableParallelBuilding = true;

  installTargets = [ "install" ];

  outputs = [ "out" "man" ];

  checkInputs = [
    xvfb_run
    hicolor-icon-theme
    imagemagick
    libtiff
    djvulibre
    poppler_utils
    ghostscript
    file
    pdftk
    unpaper
  ];

  checkPhase = ''
    xvfb-run -s '-screen 0 800x600x24' \
      make test
  '';

  meta = {
    description = "A GUI to produce PDFs or DjVus from scanned documents";
    homepage = http://gscan2pdf.sourceforge.net/;
    license = licenses.gpl3;
    maintainers = [ maintainers.pacien ];
  };
}

