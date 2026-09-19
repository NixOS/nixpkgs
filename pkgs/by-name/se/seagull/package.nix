{
  lib,
  stdenv,
  fetchhg,
  meson,
  ninja,
  pkg-config,
  gobject-introspection,
  gi-docgen,
  glib,
  sqlite,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "seagull";
  version = "0.5.0";

  src = fetchhg {
    url = "https://keep.imfreedom.org/seagull/seagull";
    rev = "v${finalAttrs.version}";
    hash = "sha256-SXpyRO23s3xzDQ2kUbwsVaIhba7R0EAbQaojm6PBvgw=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection
    gi-docgen
  ];

  buildInputs = [
    glib
    sqlite
    gi-docgen
  ];

  strictDeps = true;

  doCheck = true;

  meta = {
    description = "GObject binding for SQLite3";
    homepage = "https://keep.imfreedom.org/seagull/seagull";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.unix;
  };
})
