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
  libidn,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hasl";
  version = "0.3.2";

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  src = fetchhg {
    url = "https://keep.imfreedom.org/hasl/hasl";
    rev = "v${finalAttrs.version}";
    hash = "sha256-+/SVsHeejHRDcBi9+wRoHGLpOUH/GjT19xwbUx7a/Dg=";
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
    libidn
  ];

  strictDeps = true;

  meta = {
    description = "Hassle-free Authentication and Security Layer client library";
    homepage = "https://keep.imfreedom.org/hasl/hasl";
    license = lib.licenses.lgpl2Plus;
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.unix;
  };
})
