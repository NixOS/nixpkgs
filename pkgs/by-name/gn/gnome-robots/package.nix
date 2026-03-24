{
  lib,
  stdenv,
  cargo,
  desktop-file-utils,
  fetchurl,
  glib,
  gnome,
  gtk4,
  itstool,
  libadwaita,
  librsvg,
  libxml2,
  gst_all_1,
  meson,
  ninja,
  pkg-config,
  rustc,
  rustPlatform,
  wrapGAppsHook4,
  _experimental-update-script-combinators,
  common-updater-scripts,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-robots";
  version = "50.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-robots/${lib.versions.major finalAttrs.version}/gnome-robots-${finalAttrs.version}.tar.xz";
    hash = "sha256-YX5XTBX5Bhi4JJPJk51xdZatLOH/HeCq1cnDl2Yz03k=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src;
    name = "gnome-robots-${finalAttrs.version}";
    hash = "sha256-T3o4zlRLQzrLexSDI9A98bubehYFwJY1zBVUUNmrc9o=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    cargo
    rustc
    rustPlatform.cargoSetupHook
    gtk4 # for gtk4-update-icon-cache
    wrapGAppsHook4
    itstool
    desktop-file-utils
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
    librsvg
    libxml2
    # Sound playback, not checked at build time.
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
  ];

  preFixup = ''
    # Seal GStreamer plug-ins so that we can notice when they are missing.
    gappsWrapperArgs+=(--set "GST_PLUGIN_SYSTEM_PATH_1_0" "$GST_PLUGIN_SYSTEM_PATH_1_0")
    unset GST_PLUGIN_SYSTEM_PATH_1_0
  '';

  passthru = {
    updateScript =
      let
        updateSource = gnome.updateScript {
          packageName = "gnome-robots";
        };

        updateLockfile = {
          command = [
            "sh"
            "-c"
            ''
              PATH=${
                lib.makeBinPath [
                  common-updater-scripts
                ]
              }
              update-source-version gnome-robots --ignore-same-version --source-key=cargoDeps.vendorStaging > /dev/null
            ''
          ];
          # Experimental feature: do not copy!
          supportedFeatures = [ "silent" ];
        };
      in
      _experimental-update-script-combinators.sequence [
        updateSource
        updateLockfile
      ];
  };

  meta = {
    homepage = "https://gitlab.gnome.org/GNOME/gnome-robots";
    changelog = "https://gitlab.gnome.org/GNOME/gnome-robots/-/blob/${finalAttrs.version}/NEWS?ref_type=tags";
    description = "Avoid the robots and make them crash into each other";
    mainProgram = "gnome-robots";
    teams = [ lib.teams.gnome ];
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
  };
})
