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
  version = "0.8.4";

  outputs = [
    "out"
    "man"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    hash = "sha256-j6BNTr3BVbCiOd+IvZ8J6PJznVcHoTkLQnq0mF+D0lo=";
  };

  patches = [
    # Revert to avoid manpages breakage:
    #   https://gitlab.gnome.org/GNOME/libnotify/-/merge_requests/37#note_2366448
    (fetchpatch {
      revert = true;
      name = "unbreak-man.path";
      url = "https://gitlab.gnome.org/GNOME/libnotify/-/commit/2f99025b7ad54f29dc5236aa7dfcfa97d1c8efde.patch";
      hash = "sha256-/qbBs+bJjzCR2I7swy0RTsTaXap+gkYzvfchobeOzPQ=";
    })
  ];

  mesonFlags = [
    # disable tests as we don't need to depend on GTK (2/3)
    "-Dtests=false"
    "-Ddocbook_docs=disabled"
    "-Dgtk_doc=false"
    "-Dintrospection=${if withIntrospection then "enabled" else "disabled"}"
  ];

  strictDeps = true;

  nativeBuildInputs =
    [
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
    maintainers = teams.gnome.members;
    mainProgram = "notify-send";
    platforms = platforms.unix;
  };
}
