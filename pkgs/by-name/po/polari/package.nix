{
  stdenv,
  lib,
  itstool,
  fetchurl,
<<<<<<< HEAD
  gdk-pixbuf,
  telepathy-glib,
  telepathy-idle,
  telepathy-mission-control,
=======
  fetchpatch,
  gdk-pixbuf,
  telepathy-glib,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  gjs,
  meson,
  ninja,
  gettext,
<<<<<<< HEAD
=======
  telepathy-idle,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  libxml2,
  desktop-file-utils,
  pkg-config,
  gtk4,
  tinysparql,
  libadwaita,
  gtk3,
  glib,
<<<<<<< HEAD
  glib-networking,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  libsecret,
  libsoup_3,
  webkitgtk_4_1,
  gobject-introspection,
  gnome,
  wrapGAppsHook4,
  gspell,
  gsettings-desktop-schemas,
}:

<<<<<<< HEAD
stdenv.mkDerivation (finalAttrs: {
  pname = "polari";
  version = "49.0";

  src = fetchurl {
    url = "mirror://gnome/sources/polari/${lib.versions.major finalAttrs.version}/polari-${finalAttrs.version}.tar.xz";
    hash = "sha256-UmJv3jkJkhrFhsxMwQ8w8SOq9hVaF374hhyg5V1t6FA=";
=======
stdenv.mkDerivation rec {
  pname = "polari";
  version = "46.0";

  src = fetchurl {
    url = "mirror://gnome/sources/polari/${lib.versions.major version}/polari-${version}.tar.xz";
    hash = "sha256-0rFwnjeRiSlPU9TvFfA/i8u76MUvD0FeYvfV8Aw2CjE=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  patches = [
    # Upstream runs the thumbnailer by passing it to gjs.
    # If we wrap it in a shell script, gjs can no longer run it.
    # Let’s change the code to run the script directly by making it executable and having gjs in shebang.
    ./make-thumbnailer-wrappable.patch

<<<<<<< HEAD
    # fix TypeError: (intermediate value).get_current_event_device is not a function
    # https://gitlab.gnome.org/GNOME/polari/-/merge_requests/320
    ./0001-joinDialog-Fix-detecting-pointer-devices.patch

    # https://gitlab.gnome.org/GNOME/polari/-/merge_requests/329
    ./0002-mainWindow-Disconnect-event-handler-on-destroy.patch

    # https://gitlab.gnome.org/GNOME/polari/-/merge_requests/330
    ./0003-Add-option-to-disable-URL-preview-feature.patch

    # This also helps us to distribute the app as a single package
    # without enabling telepathy-{idle,mission-control} services
    ./check_dbus_unconditionally.patch

    # This fixes Tracker.SparqlError: table Resource already exists
    # and chat history spinning forever on second launch.
    # Fixes the race condition by ensuring all callers wait on the
    # same shared initialization promise
    ./fix_sparql_database_race.patch
  ];

  postPatch = ''
    substituteInPlace src/application.js \
      --replace-fail "/app/libexec/mission-control-5" "${lib.getLib telepathy-mission-control}/libexec/mission-control-5" \
      --replace-fail "/app/libexec/telepathy-idle" "${telepathy-idle}/libexec/telepathy-idle"
  '';
=======
    # Switch to girepository-2.0
    # https://gitlab.gnome.org/GNOME/polari/-/merge_requests/356
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/polari/-/commit/d7946c7fe39f112cd3f751bb95b170446022980d.patch";
      hash = "sha256-naRzZ5Iple11HJ+d8DL9oJy3C4VKLkz+FdMuhO7sc7k=";
    })
  ];

  propagatedUserEnvPkgs = [ telepathy-idle ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    itstool
    gettext
    wrapGAppsHook4
    libxml2
    desktop-file-utils
    gobject-introspection
  ];

  buildInputs = [
    gtk4
    tinysparql
    libadwaita
    gtk3 # for thumbnailer
    glib
<<<<<<< HEAD
    glib-networking
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    gsettings-desktop-schemas
    telepathy-glib
    gjs
    gspell
    gdk-pixbuf
    libsecret
    libsoup_3
    webkitgtk_4_1 # for thumbnailer
  ];

  postFixup = ''
    wrapGApp "$out/share/polari/thumbnailer.js"
  '';

  passthru = {
    updateScript = gnome.updateScript { packageName = "polari"; };
  };

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    homepage = "https://apps.gnome.org/Polari/";
    description = "IRC chat client designed to integrate with the GNOME desktop";
    mainProgram = "polari";
    teams = [
<<<<<<< HEAD
      lib.teams.gnome
      lib.teams.gnome-circle
    ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
=======
      teams.gnome
      teams.gnome-circle
    ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
