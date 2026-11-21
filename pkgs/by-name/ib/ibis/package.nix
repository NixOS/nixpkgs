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
  pango,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ibis";
  version = "0.14.0";

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  src = fetchhg {
    url = "https://keep.imfreedom.org/ibis/ibis";
    rev = "v${finalAttrs.version}";
    hash = "sha256-DtRn3+HyahMdpxhkg66NtaXLDgdX8VKPUaEKKe4iO0A=";
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
    pango
  ];

  strictDeps = true;

  doCheck = true;

  meta = {
    description = "GObject based IRCv3 library";
    homepage = "https://keep.imfreedom.org/ibis/ibis";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.unix;
  };
})
