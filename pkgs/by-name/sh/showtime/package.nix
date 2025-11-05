{
  lib,
  appstream,
  blueprint-compiler,
  desktop-file-utils,
  fetchurl,
  fetchpatch,
  glib,
  gnome,
  gobject-introspection,
  gst_all_1,
  gtk4,
  libadwaita,
  meson,
  ninja,
  pkg-config,
  python3Packages,
  wrapGAppsHook4,
}:

python3Packages.buildPythonApplication rec {
  pname = "showtime";
  version = "49.0";
  pyproject = false;

  src = fetchurl {
    url = "mirror://gnome/sources/showtime/${lib.versions.major version}/showtime-${version}.tar.xz";
    hash = "sha256-Wryvl6telTADgoKEhYjozmwmFztzA+9nVr69sLIO05g=";
  };

  patches = [
    # Fix startup crash when missing state directory.
    # https://gitlab.gnome.org/GNOME/showtime/-/merge_requests/80
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/showtime/-/commit/a5d57a6b023664c9dc5aeb55a3467a8b56e1b7bc.patch";
      hash = "sha256-IUkopJ3J381+9MnvaItx7dn9NAVrqO9y4LjgPh8MU/M=";
    })
  ];

  strictDeps = true;

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
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-rs
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-libav
    gst_all_1.gstreamer
    libadwaita
  ];

  dependencies = with python3Packages; [ pygobject3 ];

  dontWrapGApps = true;
  makeWrapperArgs = [ "\${gappsWrapperArgs[@]}" ];

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
}
