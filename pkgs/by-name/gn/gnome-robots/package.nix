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
  version = "41.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-robots/${lib.versions.major finalAttrs.version}/gnome-robots-${finalAttrs.version}.tar.xz";
    hash = "sha256-K4BQcFrIPpOL56iREyYB62XHk/IJzX6RDGzWQphzBHg=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src;
    name = "gnome-robots-${finalAttrs.version}";
    hash = "sha256-7kwjpZJqAqqKlt6mOFyjaaxZ1Tr2WuhE72jwjCZpX9E=";
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

  postPatch = ''
    # https://gitlab.gnome.org/GNOME/gnome-robots/-/merge_requests/38
    substituteInPlace data/icons/meson.build \
      --replace-fail 'gtk-update-icon-cache' 'gtk4-update-icon-cache'
  '';

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
              update-source-version gnome-robots --ignore-same-version --source-key=cargoDeps > /dev/null
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

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/GNOME/gnome-robots";
    changelog = "https://gitlab.gnome.org/GNOME/gnome-robots/-/blob/${finalAttrs.version}/NEWS?ref_type=tags";
    description = "Avoid the robots and make them crash into each other";
    mainProgram = "gnome-robots";
    maintainers = teams.gnome.members;
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
  };
})
