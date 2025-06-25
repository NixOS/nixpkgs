{
  lib,
  stdenv,
  fetchurl,
  appstream,
  blueprint-compiler,
  desktop-file-utils,
  gjs,
  gst_all_1,
  libadwaita,
  meson,
  ninja,
  pkg-config,
  typescript,
  wrapGAppsHook4,
  gnome,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "decibels";
  version = "48.0";

  src = fetchurl {
    url = "mirror://gnome/sources/decibels/${lib.versions.major finalAttrs.version}/decibels-${finalAttrs.version}.tar.xz";
    hash = "sha256-IpsRqSYxR7y4w+If8NSvZZ+yYmL4rs5Uetz4xl4DH3Q=";
  };

  nativeBuildInputs = [
    appstream
    blueprint-compiler
    desktop-file-utils
    meson
    ninja
    pkg-config
    typescript
    wrapGAppsHook4
  ];

  buildInputs = [
    gjs
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base # for GstVideo
    gst_all_1.gst-plugins-bad # for GstPlay
    gst_all_1.gst-plugins-good # for scaletempo
    gst_all_1.gst-libav
    libadwaita
  ];

  # NOTE: this is applied after install to ensure `tsc` doesn't
  # mess with us
  #
  # gjs uses the invocation name to add gresource files
  # to get around this, we set the entry point name manually
  preFixup = ''
    sed -i "1 a imports.package._findEffectiveEntryPointName = () => 'org.gnome.Decibels';" $out/bin/org.gnome.Decibels
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "decibels";
    };
  };

  meta = {
    description = "Play audio files";
    homepage = "https://gitlab.gnome.org/GNOME/decibels";
    changelog = "https://gitlab.gnome.org/GNOME/decibels/-/blob/${finalAttrs.version}/NEWS?ref_type=tags";
    license = lib.licenses.gpl3Only;
    teams = [
      lib.teams.gnome
      lib.teams.gnome-circle
    ];
    mainProgram = "org.gnome.Decibels";
    platforms = lib.platforms.linux;
  };
})
