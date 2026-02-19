{
  stdenv,
  lib,
  fetchurl,
  libglycin,
  glycin-loaders,
  cargo,
  desktop-file-utils,
  meson,
  ninja,
  pkg-config,
  rustc,
  rustPlatform,
  wrapGAppsHook4,
  glib,
  gst_all_1,
  gtk4,
  libadwaita,
  libcamera,
  lcms2,
  libseccomp,
  pipewire,
  gnome,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "snapshot";
  version = "49.1";

  src = fetchurl {
    url = "mirror://gnome/sources/snapshot/${lib.versions.major finalAttrs.version}/snapshot-${finalAttrs.version}.tar.xz";
    hash = "sha256-NVj2+ODTiylQtrrZue7COCSb7f7c5w+1iijK1pRebOk=";
  };

  cargoVendorDir = "vendor";

  nativeBuildInputs = [
    cargo
    desktop-file-utils
    libglycin.patchVendorHook
    meson
    ninja
    pkg-config
    rustc
    rustPlatform.cargoSetupHook
    wrapGAppsHook4
  ];

  buildInputs = [
    glib
    libglycin.setupHook
    glycin-loaders
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-rs # for gtk4paintablesink
    gst_all_1.gstreamer
    gtk4
    libadwaita
    libcamera # for the gstreamer plugin
    lcms2
    libseccomp
    pipewire # for device provider
  ];

  postPatch = ''
    substituteInPlace src/meson.build --replace-fail \
      "'src' / rust_target / meson.project_name()" \
      "'src' / '${stdenv.hostPlatform.rust.cargoShortTarget}' / rust_target / meson.project_name()"
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      # vp8enc preset
      --prefix GST_PRESET_PATH : "${gst_all_1.gst-plugins-good}/share/gstreamer-1.0/presets"
    )
  '';

  # For https://gitlab.gnome.org/GNOME/snapshot/-/blob/34236a6dded23b66fdc4e4ed613e5b09eec3872c/src/meson.build#L57
  env.CARGO_BUILD_TARGET = stdenv.hostPlatform.rust.rustcTargetSpec;

  passthru.updateScript = gnome.updateScript {
    packageName = "snapshot";
  };

  meta = {
    homepage = "https://gitlab.gnome.org/GNOME/snapshot";
    description = "Take pictures and videos on your computer, tablet, or phone";
    teams = [ lib.teams.gnome ];
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
    mainProgram = "snapshot";
  };
})
