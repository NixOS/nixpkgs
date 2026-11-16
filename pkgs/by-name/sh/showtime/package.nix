{
  lib,
  appstream,
  blueprint-compiler,
  desktop-file-utils,
  fetchurl,
  glib,
  gnome,
  gobject-introspection,
  gstreamer,
  gst-plugins-ugly,
  gst-plugins-rs,
  gst-plugins-good,
  gst-plugins-base,
  gst-plugins-bad,
  gst-libav,
  gtk4,
  libadwaita,
  meson,
  ninja,
  pkg-config,
  python3Packages,
  wrapGAppsHook4,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "showtime";
  version = "50.0";
  pyproject = false;

  src = fetchurl {
    url = "mirror://gnome/sources/showtime/${lib.versions.major finalAttrs.version}/showtime-${finalAttrs.version}.tar.xz";
    hash = "sha256-Q5nJ+n9h5ZhCQuJ5rNFRm+7CRrmKZ21EpLKrlOnuywE=";
  };

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    appstream
    blueprint-compiler
    desktop-file-utils
    glib # For `glib-compile-schemas`
    gobject-introspection
    gtk4 # For `gtk-update-icon-cache`
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    gst-plugins-bad
    gst-plugins-base
    gst-plugins-good
    gst-plugins-rs
    gst-plugins-ugly
    gst-libav
    gstreamer
    libadwaita
  ];

  dependencies = with python3Packages; [ pygobject3 ];

  dontWrapGApps = true;
  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  pythonImportsCheck = [ "showtime" ];

  preInstallCheck = ''
    export XDG_DATA_DIRS="${glib.makeSchemaDataDirPath "$out" "$name"}:$XDG_DATA_DIRS"
    export HOME="$TEMPDIR"
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "showtime";
    };
  };

  meta = {
    description = "Watch without distraction";
    homepage = "https://apps.gnome.org/Showtime";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ getchoo ];
    teams = [ lib.teams.gnome ];
    mainProgram = "showtime";
  };
})
