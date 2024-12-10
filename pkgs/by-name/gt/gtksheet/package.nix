{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  gobject-introspection,
  gtk-doc,
  pkg-config,
  atk,
  cairo,
  glade,
  gtk3,
  pango,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gtksheet";
  version = "4.3.13";

  src = fetchFromGitHub {
    owner = "fpaquet";
    repo = "gtksheet";
    rev = "V${finalAttrs.version}";
    hash = "sha256-2JwkyT6OBApfgyfNSksbrusF8WcZ4v3tlbblDJJtN2k=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    gobject-introspection
    gtk-doc
    pkg-config
  ];

  buildInputs = [
    atk
    cairo
    glade
    gtk3
    pango
  ];

  meta = {
    description = "A spreadsheet widget for GTK+";
    homepage = "https://fpaquet.github.io/gtksheet/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ wegank ];
    platforms = lib.platforms.unix;
  };
})
