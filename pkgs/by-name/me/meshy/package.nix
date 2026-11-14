{
  lib,
  stdenv,
  fetchFromCodeberg,
  meson,
  ninja,
  pkg-config,
  python3,
  glib,
  gtk4,
  libadwaita,
  libshumate,
  geoclue2,
  gobject-introspection,
  wrapGAppsHook4,
  desktop-file-utils,
  appstream,
  gettext,
  gst_all_1,
  zbar,
  qrScanner ? true,
  shortcutsDialog ? lib.versionAtLeast libadwaita.version "1.8",
}:
let
  python = python3.withPackages (
    ps:
    [
      ps.pygobject3
      ps.pycryptodome
      ps.pyserial
      ps.segno
    ]
    ++ lib.optionals qrScanner [
      ps.pyzbar
    ]
  );
in
stdenv.mkDerivation (finalAttrs: {
  pname = "meshy";
  version = "26.09";

  src = fetchFromCodeberg {
    owner = "sesivany";
    repo = "meshy";
    rev = "${finalAttrs.version}";
    hash = "sha256-U23MuusLKePra/qe+J1Co7aeIwmVmKTegE8BM8j4md4=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python
    glib
    gtk4
    gobject-introspection
    wrapGAppsHook4
    desktop-file-utils
    appstream
    gettext
  ];

  buildInputs = [
    python
    glib
    gtk4
    libadwaita
    libshumate
    geoclue2
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
  ]
  ++ lib.optionals qrScanner [
    zbar
  ];

  mesonFlags = [
    (lib.mesonBool "qr_scanner" qrScanner)
    (lib.mesonBool "shortcuts_dialog" shortcutsDialog)
  ];

  preFixup = ''
    meshyInit="$(find "$out" -type f -path '*/meshy/__init__.py' -print -quit)"

    if [ -z "$meshyInit" ]; then
      echo "Meshy's Python module was not installed under $out" >&2
      exit 1
    fi

    meshyPythonPath="$(dirname "$(dirname "$meshyInit")")"

    gappsWrapperArgs+=(
      --prefix PYTHONPATH : "$meshyPythonPath:${python}/${python.sitePackages}"
    )
  ''
  + lib.optionalString qrScanner ''
    gappsWrapperArgs+=(
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ zbar ]}"
    )
  '';

  meta = {
    description = "GTK4/libadwaita client for MeshCore";
    homepage = "https://codeberg.org/sesivany/meshy";
    platforms = lib.platforms.linux;
  };
})
