{
  arrow-cpp,
  glib,
  gobject-introspection,
  lib,
  meson,
  ninja,
  pkg-config,
  python3,
  stdenv,
}:

stdenv.mkDerivation {
  pname = "arrow-glib";
  inherit (arrow-cpp) src version;
  sourceRoot = "${arrow-cpp.src.name}/c_glib";

  strictDeps = true;

  nativeBuildInputs = [
    meson
    ninja
    python3
    pkg-config
    gobject-introspection
  ];

  buildInputs = [
    arrow-cpp
    glib
  ];

  meta = {
    inherit (arrow-cpp.meta) license platforms;
    description = "GLib bindings for Apache Arrow";
    homepage = "https://arrow.apache.org/docs/c_glib/";
    maintainers = with lib.maintainers; [ amarshall ];
  };
}
