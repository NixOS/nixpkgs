{
  lib,
  stdenv,
  fetchFromGitLab,
  pkg-config,
  gtk4,
  vala,
  enchant2,
  wrapGAppsHook3,
  meson,
  ninja,
  desktop-file-utils,
  gnome-online-accounts,
  gsettings-desktop-schemas,
  adwaita-icon-theme,
  libpeas,
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
  gnome,
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
}:

stdenv.mkDerivation rec {
  pname = "geary";
  version = "0-unstable-2025-07-17";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "geary";
    rev = "fd11f578ec0e26b94f9e7155b6da37351f95c33f";
    hash = "sha256-j8ETKBj5zABQMiMC10oe7ypnbhXV9f51fXQO7idduMQ=";
  };

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
    enchant2
    folks
    glib-networking
    gmime3
    gnome-online-accounts
    gsettings-desktop-schemas
    gsound
    gspell
    gtk4
    isocodes
    icu
    json-glib
    libgee
    libhandy
    libpeas
    libsecret
    libunwind
    libstemmer
    libxml2
    libytnef
    sqlite
    webkitgtk_6_0
    gcr_4
    libspelling
    libadwaita
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

  strictDeps = true;

  postPatch = ''
    chmod +x build-aux/git_version.py

    patchShebangs build-aux/git_version.py

    # Only used for generating .pot file
    # https://gitlab.gnome.org/GNOME/geary/-/merge_requests/856
    #substituteInPlace meson.build \
    #  --replace-fail "appstream_glib = dependency('appstream-glib', version: '>=0.7.10')" ""

    chmod +x desktop/geary-attach
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

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "geary";
    };
  };

  meta = {
    homepage = "https://gitlab.gnome.org/GNOME/geary";
    changelog = "https://gitlab.gnome.org/GNOME/geary/-/blob/${version}/NEWS?ref_type=tags";
    description = "Mail client for GNOME 3";
    teams = [ lib.teams.gnome ];
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
}
