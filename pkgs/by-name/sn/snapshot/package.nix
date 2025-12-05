{
  stdenv,
  lib,
  fetchurl,
  libglycin,
  glycin-loaders,
  cargo,
  desktop-file-utils,
  jq,
  meson,
  moreutils,
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
  version = "49.0";

  src = fetchurl {
    url = "mirror://gnome/sources/snapshot/${lib.versions.major finalAttrs.version}/snapshot-${finalAttrs.version}.tar.xz";
    hash = "sha256-X5YZPSkZxzVXRdJqGwHyPDyzCpPHQtWD7EKSfEpFrhg=";
  };

  patches = [
    # Fix paths in glycin library
    libglycin.passthru.glycin3PathsPatch
  ];

  cargoVendorDir = "vendor";

  nativeBuildInputs = [
    cargo
    desktop-file-utils
    jq
    meson
    moreutils # sponge is used in postPatch
    ninja
    pkg-config
    rustc
    rustPlatform.cargoSetupHook
    wrapGAppsHook4
  ];

  buildInputs = [
    glib
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
    # Replace hash of file we patch in vendored glycin.
    jq \
      --arg hash "$(sha256sum vendor/glycin/src/sandbox.rs | cut -d' ' -f 1)" \
      '.files."src/sandbox.rs" = $hash' \
      vendor/glycin/.cargo-checksum.json \
      | sponge vendor/glycin/.cargo-checksum.json

    substituteInPlace src/meson.build --replace-fail \
      "'src' / rust_target / meson.project_name()" \
      "'src' / '${stdenv.hostPlatform.rust.cargoShortTarget}' / rust_target / meson.project_name()"
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      # vp8enc preset
      --prefix GST_PRESET_PATH : "${gst_all_1.gst-plugins-good}/share/gstreamer-1.0/presets"
      # See https://gitlab.gnome.org/sophie-h/glycin/-/blob/0.1.beta.2/glycin/src/config.rs#L44
      --prefix XDG_DATA_DIRS : "${glycin-loaders}/share"
    )
  '';

  # For https://gitlab.gnome.org/GNOME/snapshot/-/blob/34236a6dded23b66fdc4e4ed613e5b09eec3872c/src/meson.build#L57
  env.CARGO_BUILD_TARGET = stdenv.hostPlatform.rust.rustcTargetSpec;

  passthru.updateScript = gnome.updateScript {
    packageName = "snapshot";
  };

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/GNOME/snapshot";
    description = "Take pictures and videos on your computer, tablet, or phone";
    teams = [ teams.gnome ];
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    mainProgram = "snapshot";
  };
})
