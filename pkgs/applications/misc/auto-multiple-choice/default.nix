{ lib
, stdenv
, fetchurl
, perlPackages
, makeWrapper
, wrapGAppsHook3
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
stdenv.mkDerivation (finalAttrs: rec {
  pname = "auto-multiple-choice";
  version = "1.6.0";
  src = fetchurl {
    url = "https://download.auto-multiple-choice.net/${pname}_${version}_dist.tar.gz";
    # before 1.6.0, the URL pattern used "precomp" instead of "dist".    ^^^^
    sha256 = "sha256-I9Xw1BN8ZSQhi5F1R3axHBKE6tnaCNk8k5tts6LoMjY=";
  };

  # There's only the Makefile
  dontConfigure = true;

  makeFlags = [
    "PERLPATH=${perl}/bin/perl"
    # We *need* to set DESTDIR as empty and use absolute paths below,
    # because the Makefile ignores PREFIX and MODSDIR is required to
    # be an absolute path to not trigger "portable distribution" check
    # in auto-multiple-choice.in.
    "DESTDIR="
    # Set variables from Makefile.conf to absolute paths
    "BINDIR=${placeholder "out"}/bin"
    "PERLDIR=${placeholder "out"}/share/perl5"
    "MODSDIR=${placeholder "out"}/lib"
    "TEXDIR=${placeholder "out"}/tex/latex/" # what texlive.combine expects
    "TEXDOCDIR=${placeholder "out"}/share/doc/texmf/" # TODO where to put this?
    "MAN1DIR=${placeholder "out"}/share/man/man1"
    "DESKTOPDIR=${placeholder "out"}/share/applications"
    "METAINFODIR=${placeholder "out"}/share/metainfo"
    "ICONSDIR=${placeholder "out"}/share/auto-multiple-choice/icons"
    "CSSDIR=${placeholder "out"}/share/auto-multiple-choice/gtk"
    "APPICONDIR=${placeholder "out"}/share/icons/hicolor"
    "LOCALEDIR=${placeholder "out"}/share/locale"
    "MODELSDIR=${placeholder "out"}/share/auto-multiple-choice/models"
    "DOCDIR=${placeholder "out"}/share/doc/auto-multiple-choice"
    "SHARED_MIMEINFO_DIR=${placeholder "out"}/share/mime/packages"
    "LANG_GTKSOURCEVIEW_DIR=${placeholder "out"}/share/gtksourceview-4/language-specs"
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
    --prefix PATH : "$out/bin" \
    --set TEXINPUTS ":.:$out/tex/latex"
  '';

  nativeBuildInputs = [
    pkg-config
    makeWrapper
    wrapGAppsHook3
    gobject-introspection
  ];

  buildInputs = [
    cairo
    cairo.dev
    dblatex
    gnumake
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

  passthru = {
    tlType = "run";
    pkgs = [ finalAttrs.finalPackage ];
  };

  meta = with lib; {
    description = "Create and manage multiple choice questionnaires with automated marking";
    mainProgram = "auto-multiple-choice";
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
          inherit auto-multiple-choice;
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
})
