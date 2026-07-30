{
  lib,
  stdenv,
  fetchFromGitHub,
  cargo,
  meson,
  ninja,
  pkg-config,
  protobuf,
  rustPlatform,
  rustc,
  wrapGAppsHook4,
  cairo,
  dbus,
  gdk-pixbuf,
  glib,
  gtk4,
  libadwaita,
  pango,
  blueprint-compiler,
  desktop-file-utils,
  appstream,
  python3Packages,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "packet";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "nozwock";
    repo = "packet";
    tag = finalAttrs.version;
    hash = "sha256-zR2WZER49xsxaiZbFGFOukHE3w0odxVi9WJTI4FSWJ0=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-ODrM8oGQpi+DpG4YQYibtVHbicuHOjZAlZ1wW2Gulec=";
  };

  nativeBuildInputs = [
    cargo
    meson
    ninja
    pkg-config
    protobuf
    rustPlatform.cargoSetupHook
    rustc
    wrapGAppsHook4
    blueprint-compiler
    desktop-file-utils
    glib
    gtk4
    appstream
  ];

  buildInputs = [
    cairo
    dbus
    gdk-pixbuf
    libadwaita
    pango
    python3Packages.wrapPython
  ];

  postFixup = ''
    buildPythonPath ${python3Packages.dbus-python}
    patchPythonScript $out/share/packet/plugins/packet_nautilus.py
    # install the nautilus extension in the expected location
    mkdir -p $out/share/nautilus-python
    ln -s $out/share/packet/plugins $out/share/nautilus-python/extensions
  '';

  meta = {
    description = "Quick Share client for Linux";
    homepage = "https://github.com/nozwock/packet";
    changelog = "https://github.com/nozwock/packet/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ontake ];
    mainProgram = "packet";
    platforms = lib.platforms.linux;
  };
})
