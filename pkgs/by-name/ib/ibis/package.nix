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
  birb,
  hasl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ibis";
  version = "0.10.1";

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  src = fetchhg {
    url = "https://keep.imfreedom.org/ibis/ibis";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ivK0qGp2vM2fSff01SCGfw6TqcoWRDIMvGZgQooXErQ=";
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
    birb
    hasl
  ];

  strictDeps = true;

  meta = {
    description = "GObject based IRCv3 library";
    homepage = "https://keep.imfreedom.org/ibis/ibis";
    license = lib.licenses.lgpl2Plus;
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.unix;
  };
})
