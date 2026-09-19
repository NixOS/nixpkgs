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
  version = "0.5.0";

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  src = fetchhg {
    url = "https://keep.imfreedom.org/birb/birb";
    rev = "v${finalAttrs.version}";
    hash = "sha256-KoqTJuLjTdIOygsaHIBgh9ZFBYXle1JtBW3aTgCQAIQ=";
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

  doCheck = true;

  meta = {
    description = "Library of utilities for GLib based applications";
    homepage = "https://keep.imfreedom.org/birb/birb";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.unix;
  };
})
