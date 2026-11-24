{
  lib,
  stdenv,
  fetchFromGitHub,
  gitUpdater,
  vala,
  meson,
  ninja,
  pkg-config,
  pantheon,
  gettext,
  wrapGAppsHook3,
  desktop-file-utils,
  gtk3,
  glib,
  libgee,
  libgda5,
  gtksourceview4,
  libxml2,
  libsecret,
  libssh2,
}:

let
  sqlGda = libgda5.override {
    mysqlSupport = true;
    postgresSupport = true;
  };

in
stdenv.mkDerivation (finalAttrs: {
  pname = "sequeler";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "ellie-commons";
    repo = "sequeler";
    tag = "v${finalAttrs.version}";
    hash = "sha256-woZkQP28+SloWSkLhtlvkR3RpJE0iGT64cXAfM3JsEI=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    gettext
    wrapGAppsHook3
    desktop-file-utils
  ];

  buildInputs = [
    gtk3
    glib
    pantheon.granite
    pantheon.elementary-icon-theme
    libgee
    sqlGda
    gtksourceview4
    libxml2
    libsecret
    libssh2
  ];

  postPatch = ''
    # Avoid flatpak-specific theme setting.
    # https://github.com/ellie-commons/sequeler/pull/436#discussion_r2649202543
    # https://github.com/elementary/flatpak-platform/blob/9.1.0/io.elementary.Sdk.json.in#L229
    substituteInPlace src/Application.vala --replace-fail \
      'gtk_settings.gtk_theme_name = "elementary"' \
      'gtk_settings.gtk_theme_name = "io.elementary.stylesheet.blueberry"'
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      # The GTK theme is hardcoded.
      --prefix XDG_DATA_DIRS : "${pantheon.elementary-gtk-theme}/share"
      # The icon theme is hardcoded.
      --prefix XDG_DATA_DIRS : "$XDG_ICON_DIRS"
    )
  '';

  passthru = {
    updateScript = gitUpdater {
      # Upstream frequently tags these to fix flatpak builds, which are mostly irrelevant to us.
      ignoredVersions = "-";
      rev-prefix = "v";
    };
  };

  meta = {
    description = "Friendly SQL Client";
    longDescription = ''
      Sequeler is a native Linux SQL client built in Vala and Gtk. It allows you
      to connect to your local and remote databases, write SQL in a handy text
      editor with language recognition, and visualize SELECT results in a
      Gtk.Grid Widget.
    '';
    homepage = "https://github.com/ellie-commons/sequeler";
    license = lib.licenses.gpl3Plus;
    teams = [ lib.teams.pantheon ];
    platforms = lib.platforms.linux;
    mainProgram = "io.github.ellie_commons.sequeler";
  };
})
