{
  lib,
  rustPlatform,
  fetchFromGitHub,
  glib-networking,
  pkg-config,
  wrapGAppsHook4,
  nix-update-script,
  libxkbcommon,
  wayland,
  glib,
  gobject-introspection,
  gtk4,
  libadwaita,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nmrs-gui";
  version = "1.5.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "networkmanager-rs";
    repo = "nmrs-gui";
    rev = "182150da4f4e05a2b4d5c9dd03d8b0c78ec5c048";
    hash = "sha256-Q9ZZeAGMMgUfiMd+a7wF+lKKdU9K1w0oplvJos3UGGE=";
  };

  cargoHash = "sha256-+3s8UXESAh8FuOtSMvcVQ3DExPapYe0n4VKYyFnTlj4=";

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    glib-networking
    libxkbcommon
    wayland
    glib
    gobject-introspection
    gtk4
    libadwaita
  ];

  preCheck = ''
    export XDG_RUNTIME_DIR="$TMPDIR"
    export XDG_DATA_HOME="$TMPDIR"
  '';

  checkFlags = [
    # these 2 tests try to initialize GTK, which isn't avail in sandbox.
    "--skip=app_initializes_without_panic"
    "--skip=style_css_loads"
  ];

  passthru.updateScript = nix-update-script { };

  postInstall = ''
    install -D nmrs.desktop -t $out/share/applications
  '';

  meta = {
    description = "Wayland-native frontend for NetworkManager";
    homepage = "https://github.com/networkmanager-rs/nmrs-gui";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      cachebag
      joncorv
    ];
    mainProgram = "nmrs-gui";
    platforms = lib.platforms.linux;
  };
})
