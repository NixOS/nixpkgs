{
  lib,
  stdenv,
  blueprint-compiler,
  fetchurl,
  pkg-config,
  meson,
  gettext,
  gobject-introspection,
  glib,
  gnome,
  gtksourceview5,
  gjs,
  webkitgtk_6_0,
  wrapGAppsHook4,
  gst_all_1,
  gtk4,
  libadwaita,
  harfbuzz,
  ninja,
  papers,
  fribidi,
  libglycin,
  libglycin-gtk4,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sushi";
  version = "51.beta";

  src = fetchurl {
    url = "mirror://gnome/sources/sushi/${lib.versions.major finalAttrs.version}/sushi-${finalAttrs.version}.tar.xz";
    hash = "sha256-41Zsw5YZwO8TtFDmgYBob1jAD/8egK92wajBMN7D744=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    gettext
    gobject-introspection
    blueprint-compiler
    wrapGAppsHook4
  ];

  buildInputs = [
    glib
    harfbuzz
    gjs
    gtk4
    libglycin
    libglycin.setupHook
    libglycin-gtk4
    libadwaita
    gtksourceview5
    webkitgtk_6_0
    papers
    fribidi
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    (gst_all_1.gst-plugins-good.override { gtkSupport = true; })
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
  ];

  postPatch = ''
    substituteInPlace meson.build \
      --replace-fail "gjs = find_program('gjs', 'gjs-console')" "gjs = find_program('${lib.getExe gjs}')"
  '';

  # See https://github.com/NixOS/nixpkgs/issues/31168
  postInstall = ''
    for file in $out/libexec/org.gnome.NautilusPreviewer
    do
      sed -e $"2iimports.package._findEffectiveEntryPointName = () => \'$(basename $file)\' " \
        -i $file
    done
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "sushi";
    };
  };

  strictDeps = true;

  meta = {
    homepage = "https://gitlab.gnome.org/GNOME/sushi";
    changelog = "https://gitlab.gnome.org/GNOME/sushi/-/blob/${finalAttrs.version}/NEWS?ref_type=tags";
    description = "Quick previewer for Nautilus";
    mainProgram = "sushi";
    teams = [ lib.teams.gnome ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
