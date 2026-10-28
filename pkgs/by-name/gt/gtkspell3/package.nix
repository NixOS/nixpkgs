{
  lib,
  stdenv,
  fetchurl,
  gtk3,
  aspell,
  pkg-config,
  enchant,
  isocodes,
  intltool,
  gobject-introspection,
  vala,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gtkspell";
  version = "3.0.10";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://sourceforge/gtkspell/gtkspell3-${finalAttrs.version}.tar.xz";
    sha256 = "0cjp6xdcnzh6kka42w9g0w2ihqjlq8yl8hjm9wsfnixk6qwgch5h";
  };

  nativeBuildInputs = [
    pkg-config
    intltool
    gobject-introspection
    vala
  ];
  buildInputs = [
    aspell
    gtk3
    enchant
    isocodes
  ];
  propagatedBuildInputs = [ enchant ];

  configureFlags = [
    "--enable-introspection"
    "--enable-vala"
  ];

  meta = {
    homepage = "https://gtkspell.sourceforge.net/";
    description = "Word-processor-style highlighting GtkTextView widget";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
})
