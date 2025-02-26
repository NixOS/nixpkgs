{
  lib,
  stdenv,
  fetchhg,
  meson,
  ninja,
  pkg-config,
  gobject-introspection,
  glib,
  gi-docgen,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "birb";
  version = "0.2.0";

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  src = fetchhg {
    url = "https://keep.imfreedom.org/birb/birb";
    rev = "v${finalAttrs.version}";
    hash = "sha256-nwENPzc4OOIZM+xGoAtl1JYeBkoe9vf6iH1m0snFVdQ=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection
    glib
    gi-docgen
  ];

  buildInputs = [
    glib
    gi-docgen
  ];

  strictDeps = true;

  meta = {
    description = "Library of utilities for GLib based applications";
    homepage = "https://keep.imfreedom.org/birb/birb";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.unix;
  };
})
