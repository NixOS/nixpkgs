{
  alsa-lib,
  blueprint-compiler,
  dbus,
  fetchFromCodeberg,
  gdk-pixbuf,
  glib,
  gtk4,
  gtk4-layer-shell,
  lib,
  libadwaita,
  libxkbcommon,
  pango,
  pkg-config,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gaypanel";
  version = "1.0.0";

  src = fetchFromCodeberg {
    owner = "pastthepixels";
    repo = "gaypanel";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Hli57fE4lAfhUQf4kjRqvu+QwMy2U81hMzKjSUB3aoI=";
  };

  cargoHash = "sha256-1kNqtuley4L7VAq2UgJk/BWVqKNtvrQ3sNx+J1ZTIdI=";

  __structuredAttrs = true;

  nativeBuildInputs = [
    blueprint-compiler
    pkg-config
  ];

  buildInputs = [
    alsa-lib
    dbus
    gdk-pixbuf
    glib
    gtk4
    gtk4-layer-shell
    libadwaita
    libxkbcommon
    pango
  ];

  meta = {
    description = "Panel for Wayland compositors";
    homepage = "https://codeberg.org/pastthepixels/gaypanel";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ itsyunaya ];
    mainProgram = "gaypanel";
  };
})
