{
  appstream,
  cargo,
  curl,
  desktop-file-utils,
  distrobox,
  fetchFromGitHub,
  gettext,
  gdk-pixbuf,
  glib,
  gsettings-desktop-schemas,
  gtk4,
  lib,
  libadwaita,
  makeWrapper,
  meson,
  ninja,
  nix-update-script,
  pango,
  pkg-config,
  rustc,
  rustPlatform,
  vte-gtk4,
  stdenv,
  wrapGAppsHook4,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "distroshelf";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "ranfdev";
    repo = "DistroShelf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dGz9mDcQ9lBqkLomHg0kamWZ56G/+d9YKHWPF5u5FAg=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-lNKWcpdIr1tm2m50B9uOqFQvhndAEM5ADmmPBPb8sj4=";
  };

  nativeBuildInputs = [
    appstream
    cargo
    desktop-file-utils
    gettext
    gtk4
    makeWrapper
    meson
    ninja
    pkg-config
    rustc
    rustPlatform.cargoSetupHook
    wrapGAppsHook4
  ];

  buildInputs = [
    curl
    distrobox
    libadwaita
    gdk-pixbuf
    glib
    gsettings-desktop-schemas
    gtk4
    pango
    vte-gtk4
  ];

  preFixup = ''
    wrapProgram "$out/bin/distroshelf" \
      --prefix PATH : ${
        lib.makeBinPath [
          distrobox
        ]
      } \
      --suffix XDG_DATA_DIRS : "$out/share:$GSETTINGS_SCHEMAS_PATH"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/ranfdev/DistroShelf";
    description = "GUI for Distrobox Containers";
    mainProgram = "distroshelf";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
})
