{
  lib,
  meson,
  ninja,
  gettext,
  fetchurl,
  gdk-pixbuf,
  tinysparql,
  libxml2,
  python3,
  libnotify,
  wrapGAppsHook4,
  libmediaart,
  gobject-introspection,
  gnome-online-accounts,
  grilo,
  grilo-plugins,
  pkg-config,
  gtk4,
  pango,
  glib,
  desktop-file-utils,
  appstream-glib,
  itstool,
  gnome,
  gst_all_1,
  libsoup_3,
  libadwaita,
  gsettings-desktop-schemas,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "gnome-music";
  version = "47.0";

  format = "other";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-music/${lib.versions.major version}/gnome-music-${version}.tar.xz";
    hash = "sha256-o1Qjz1IgX9cDfLCpprVw9uwvHjQubiDtfn2A2NyGpyY=";
  };

  nativeBuildInputs = [
    meson
    ninja
    gettext
    itstool
    pkg-config
    libxml2
    wrapGAppsHook4
    desktop-file-utils
    appstream-glib
    gobject-introspection
  ];

  buildInputs =
    [
      gtk4
      pango
      glib
      libmediaart
      gnome-online-accounts
      gdk-pixbuf
      python3
      grilo
      grilo-plugins
      libnotify
      libsoup_3
      libadwaita
      gsettings-desktop-schemas
      tinysparql
    ]
    ++ (with gst_all_1; [
      gstreamer
      gst-plugins-base
      gst-plugins-good
      gst-plugins-bad
      gst-plugins-ugly
      gst-libav
    ]);

  pythonPath = with python3.pkgs; [
    pycairo
    dbus-python
    pygobject3
  ];

  # Prevent double wrapping, let the Python wrapper use the args in preFixup.
  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  doCheck = false;

  # handle setup hooks better
  strictDeps = false;

  passthru = {
    updateScript = gnome.updateScript { packageName = "gnome-music"; };
  };

  meta = with lib; {
    homepage = "https://apps.gnome.org/Music/";
    description = "Music player and management application for the GNOME desktop environment";
    mainProgram = "gnome-music";
    maintainers = teams.gnome.members;
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
  };
}
