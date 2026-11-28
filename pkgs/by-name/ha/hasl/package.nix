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
  version = "0.4.0";

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  src = fetchhg {
    url = "https://keep.imfreedom.org/hasl/hasl";
    rev = "v${finalAttrs.version}";
    hash = "sha256-BYgVTtPn7GSGsC4eH0eDGnrGE4+rA8K0P9JiML9JcC4=";
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

  doCheck = true;

  meta = {
    description = "Hassle-free Authentication and Security Layer client library";
    homepage = "https://keep.imfreedom.org/hasl/hasl";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.unix;
  };
})
