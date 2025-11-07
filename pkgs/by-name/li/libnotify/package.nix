{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  meson,
  ninja,
  pkg-config,
  libxslt,
  docbook-xsl-ns,
  glib,
  gdk-pixbuf,
  gnome,
  buildPackages,
  withIntrospection ?
    lib.meta.availableOn stdenv.hostPlatform gobject-introspection
    && stdenv.hostPlatform.emulatorAvailable buildPackages,
  gobject-introspection,
}:

stdenv.mkDerivation rec {
  pname = "libnotify";
  version = "0.8.7";

  outputs = [
    "out"
    "man"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    hash = "sha256-S+FSAuxBhPzhrBWZfs5VMNK+Mv6Vc4da6xDjtXOFh0g=";
  };

  patches = [
    # build: Do not use GDesktopAppInfo if not available
    # https://gitlab.gnome.org/GNOME/libnotify/-/issues/62
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/libnotify/-/commit/13de65ad2a76255ffde5d6da91d246cd7226583b.patch";
      hash = "sha256-a1wiUQnrncPqL2OTY1sUWyvVcoI54bXPvkIkZAcC6kI=";
    })
  ];

  mesonFlags = [
    # disable tests as we don't need to depend on GTK 4
    "-Dtests=false"
    "-Ddocbook_docs=disabled"
    "-Dgtk_doc=false"
    "-Dintrospection=${if withIntrospection then "enabled" else "disabled"}"
  ];

  strictDeps = true;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    libxslt
    docbook-xsl-ns
    glib # for glib-mkenums needed during the build
  ]
  ++ lib.optionals withIntrospection [
    gobject-introspection
  ];

  propagatedBuildInputs = [
    gdk-pixbuf
    glib
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "none";
    };
  };

  meta = with lib; {
    description = "Library that sends desktop notifications to a notification daemon";
    homepage = "https://gitlab.gnome.org/GNOME/libnotify";
    license = licenses.lgpl21;
    teams = [ teams.gnome ];
    mainProgram = "notify-send";
    platforms = platforms.unix;
  };
}
