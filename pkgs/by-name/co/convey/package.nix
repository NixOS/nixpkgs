{
  lib,
  stdenv,
  fetchFromGitLab,
  pkg-config,
  gtk4,
  vala,
  enchant,
  wrapGAppsHook3,
  meson,
  ninja,
  desktop-file-utils,
  gnome-online-accounts,
  gsettings-desktop-schemas,
  adwaita-icon-theme,
  libpeas2,
  libsecret,
  gmime3,
  isocodes,
  icu,
  libxml2,
  gettext,
  sqlite,
  json-glib,
  itstool,
  libgee,
  webkitgtk_6_0,
  python3,
  gnutls,
  cacert,
  xvfb-run,
  glibcLocales,
  dbus,
  shared-mime-info,
  libunwind,
  folks,
  glib-networking,
  gobject-introspection,
  gspell,
  libstemmer,
  libytnef,
  libhandy,
  gsound,
  cmake,
  gcr_4,
  libspelling,
  libadwaita,
  gst_all_1,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "convey";
  version = "50.2-1";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "donnybeelo";
    repo = "convey";
    tag = finalAttrs.version;
    hash = "sha256-YFdAhC7xPGaqEdDuv1Kb6b1NHjivfkc+TnXEGhpkdQw=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    gobject-introspection
    itstool
    libxml2 # for xmllint for xml-stripblanks preprocessing
    meson
    ninja
    pkg-config
    python3
    vala
    wrapGAppsHook3
    cmake
  ];

  buildInputs = [
    adwaita-icon-theme
    enchant
    folks
    gcr_4
    glib-networking
    gmime3
    gnome-online-accounts
    gsettings-desktop-schemas
    gsound
    gspell
    gst_all_1.gst-plugins-base
    gst_all_1.gstreamer
    gtk4
    icu
    isocodes
    json-glib
    libadwaita
    libgee
    libhandy
    libpeas2
    libsecret
    libspelling
    libstemmer
    libunwind
    libxml2
    libytnef
    sqlite
    webkitgtk_6_0
  ];

  nativeCheckInputs = [
    dbus
    gnutls # for certtool
    cacert # trust store for glib-networking
    xvfb-run
    glibcLocales # required by Geary.ImapDb.DatabaseTest/utf8_case_insensitive_collation
  ];

  mesonFlags = [
    "-Dprofile=release"
    "-Dcontractor=enabled" # install the contractor file (Pantheon specific)
  ];

  postPatch = ''
    chmod +x build-aux/git_version.py
    patchShebangs build-aux/git_version.py
    chmod +x desktop/convey-attach
  '';

  # Some tests time out.
  doCheck = false;

  checkPhase = ''
    runHook preCheck

    NO_AT_BRIDGE=1 \
    GIO_EXTRA_MODULES=$GIO_EXTRA_MODULES:${glib-networking}/lib/gio/modules \
    HOME=$TMPDIR \
    XDG_DATA_DIRS=$XDG_DATA_DIRS:${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}:${shared-mime-info}/share:${folks}/share/gsettings-schemas/${folks.name} \
    xvfb-run -s '-screen 0 800x600x24' dbus-run-session \
      --config-file=${dbus}/share/dbus-1/session.conf \
      meson test -v --no-stdsplit

    runHook postCheck
  '';

  preFixup = ''
    # Add geary to path for geary-attach
    gappsWrapperArgs+=(--prefix PATH : "$out/bin")
  '';

  meta = {
    homepage = "https://gitlab.gnome.org/donnybeelo/convey";
    changelog = "https://gitlab.gnome.org/donnybeelo/convey/-/blob/${finalAttrs.version}/NEWS?ref_type=tags";
    description = "Mail client for GNOME 3";
    teams = [ lib.teams.gnome ];
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
})
