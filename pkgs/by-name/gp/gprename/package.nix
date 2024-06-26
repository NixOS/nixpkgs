{
  lib,
  stdenv,
  fetchzip,
  makeWrapper,
  moreutils,
  perlPackages,
  gettext,
  glib,
  gtk3,
  gobject-introspection,
  pango,
  harfbuzz,
  gdk-pixbuf,
  at-spi2-atk,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "gprename";
  version = "20230429";

  src = fetchzip {
    url = "mirror://sourceforge/gprename/gprename-${finalAttrs.version}.zip";
    hash = "sha256-Du9OO2qeB1jUEJFcVYmLbJAGi2p/IVe3sqladq09AyY=";
  };

  nativeBuildInputs = [
    makeWrapper
    moreutils
  ];

  postPatch = ''
    grep -Ev 'desktop-file-install|update-desktop-database' Makefile | sponge Makefile

    substituteInPlace Makefile \
      --replace '/usr/share' '$(DESTDIR)/share'

    substituteInPlace bin/gprename \
      --replace '/usr/share' $out/share \
      --replace '/usr/local/share' $out/share
  '';

  makeFlags = [ "DESTDIR=$(out)" ];
  buildInputs = [
    perlPackages.perl
    pango
  ];
  postInstall = ''
    wrapProgram $out/bin/gprename \
      --set PERL5LIB ${
        perlPackages.makeFullPerlPath (
          with perlPackages;
          [
            Pango
            Glib
            Gtk3
            LocaleGettext
            libintl-perl
          ]
        )
      } \
      --prefix GI_TYPELIB_PATH : ${
        lib.makeSearchPath "/lib/girepository-1.0" [
          gtk3
          pango.out
          harfbuzz
          gdk-pixbuf
          at-spi2-atk
        ]
      }
  '';

  meta = {
    description = "Complete batch renamer for files and directories";
    homepage = "https://gprename.sourceforge.net/index.php";
    license = lib.licenses.gpl3Plus;
    mainProgram = "gprename";
    maintainers = with lib.maintainers; [ quantenzitrone ];
  };
})
