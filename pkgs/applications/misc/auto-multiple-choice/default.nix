{ lib
, stdenv
, fetchurl
, perlPackages
, makeWrapper
, wrapGAppsHook
, cairo
, dblatex
, gnumake
, gobject-introspection
, graphicsmagick
, gsettings-desktop-schemas
, gtk3
, hicolor-icon-theme
, libnotify
, librsvg
, libxslt
, netpbm
, opencv
, pango
, perl
, pkg-config
, poppler
, auto-multiple-choice
}:
stdenv.mkDerivation rec {
  pname = "auto-multiple-choice";
  version = "1.5.2";
  src = fetchurl {
    url = "https://download.auto-multiple-choice.net/${pname}_${version}_precomp.tar.gz";
    sha256 = "sha256-AjonJOooSe53Fww3QU6Dft95ojNqWrTuPul3nkIbctM=";
  };
  tlType = "run";

  # There's only the Makefile
  dontConfigure = true;

  makeFlags = [
    "PERLPATH=${perl}/bin/perl"
    # We *need* to pass DESTDIR, as the Makefile ignores PREFIX.
    "DESTDIR=$(out)"
    # Relative paths.
    "BINDIR=/bin"
    "PERLDIR=/share/perl5"
    "MODSDIR=/lib" # At runtime, AMC will test for that dir before
    # defaulting to the "portable" strategy we use, so this test
    # *must* fail.  *But* this variable cannot be set to anything but
    # "/lib" , because that name is hardcoded in the main executable
    # and this variable controls both both the path AMC will check at
    # runtime, AND the path where the actual modules will be stored at
    # build-time.  This has been reported upstream as
    # https://project.auto-multiple-choice.net/issues/872
    "TEXDIR=/tex/latex/" # what texlive.combine expects
    "TEXDOCDIR=/share/doc/texmf/" # TODO where to put this?
    "MAN1DIR=/share/man/man1"
    "DESKTOPDIR=/share/applications"
    "METAINFODIR=/share/metainfo"
    "ICONSDIR=/share/auto-multiple-choice/icons"
    "APPICONDIR=/share/icons/hicolor"
    "LOCALEDIR=/share/locale"
    "MODELSDIR=/share/auto-multiple-choice/models"
    "DOCDIR=/share/doc/auto-multiple-choice"
    "SHARED_MIMEINFO_DIR=/share/mime/packages"
    "LANG_GTKSOURCEVIEW_DIR=/share/gtksourceview-4/language-specs"
    # Pretend to be redhat so `install` doesn't try to chown/chgrp.
    "SYSTEM_TYPE=rpm"
    "GCC=${stdenv.cc.targetPrefix}cc"
    "GCC_PP=${stdenv.cc.targetPrefix}c++"
  ];

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  postFixup = ''
    wrapProgram $out/bin/auto-multiple-choice \
    ''${makeWrapperArgs[@]} \
    --prefix PERL5LIB : "${with perlPackages; makeFullPerlPath [
      ArchiveZip
      DBDSQLite
      Cairo
      CairoGObject
      DBI
      Glib
      GlibObjectIntrospection
      Gtk3
      LocaleGettext
      OpenOfficeOODoc
      PerlMagick
      TextCSV
      XMLParser
      XMLSimple
      XMLWriter
    ]}:"$out/share/perl5 \
    --prefix XDG_DATA_DIRS : "$out/share:$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH" \
    --set TEXINPUTS ":.:$out/tex/latex"
  '';

  nativeBuildInputs = [
    pkg-config
    makeWrapper
    wrapGAppsHook
  ];

  buildInputs = [
    cairo
    cairo.dev
    dblatex
    gnumake
    gobject-introspection
    graphicsmagick
    gsettings-desktop-schemas
    gtk3
    hicolor-icon-theme
    libnotify
    librsvg
    libxslt
    netpbm
    opencv
    pango
    poppler
  ] ++ (with perlPackages; [
    perl
    ArchiveZip
    Cairo
    CairoGObject
    DBDSQLite
    DBI
    Glib
    GlibObjectIntrospection
    Gtk3
    LocaleGettext
    PerlMagick
    TextCSV
    XMLParser
    XMLSimple
    XMLWriter
  ]);

  meta = with lib; {
    description = "Create and manage multiple choice questionnaires with automated marking.";
    longDescription = ''
      Create, manage and mark multiple-choice questionnaires.
      auto-multiple-choice features automated or manual formatting with
      LaTeX, shuffling of questions and answers and automated marking using
      Optical Mark Recognition.

      Questionnaires can be created using either a very simple text syntax,
      AMC-TXT, or LaTeX. In the latter case, your TeXLive installation must
      be combined with this package.  This can be done in configuration.nix
      as follows:

      <screen>
      …
      environment.systemPackages = with pkgs; [
        auto-multiple-choice
        (texlive.combine {
          inherit (pkgs.texlive) scheme-full;
          extra =
            {
              pkgs = [ auto-multiple-choice ];
            };
        })
      ];
      </screen>

      For usage instructions, see documentation at the project's homepage.
    '';
    homepage = "https://www.auto-multiple-choice.net/";
    changelog = "https://gitlab.com/jojo_boulix/auto-multiple-choice/-/blob/master/ChangeLog";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.thblt ];
    platforms = platforms.all;
  };
}
