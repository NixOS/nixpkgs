{
  stdenv,
  lib,
  fetchurl,
  pkg-config,
  vala,
  glib,
  meson,
  ninja,
  libxslt,
  gtk4,
  enableBackend ? stdenv.hostPlatform.isLinux,
  json-glib,
  keyutils,
  libadwaita,
  librest_1_0,
  libxml2,
  libsecret,
  gobject-introspection,
  gettext,
  gi-docgen,
  glib-networking,
  libsoup_3,
  docbook-xsl-nons,
  gnome,
  gcr_4,
  libkrb5,
  gvfs,
  dbus,
  wrapGAppsHook4,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-online-accounts";
  version = "3.54.5";

  outputs = [
    "out"
    "dev"
  ]
  ++ lib.optionals enableBackend [
    "man"
    "devdoc"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-online-accounts/${lib.versions.majorMinor finalAttrs.version}/gnome-online-accounts-${finalAttrs.version}.tar.xz";
    hash = "sha256-6PEntTIpWimRLRwAc0kx35r/pOv8RK0N5cKWw9J9LJU=";
  };

  mesonFlags = [
    "-Dfedora=false" # not useful in NixOS or for NixOS users.
    "-Dgoabackend=${lib.boolToString enableBackend}"
    "-Ddocumentation=${lib.boolToString enableBackend}"
    "-Dman=${lib.boolToString enableBackend}"
    "-Dwebdav=true"
  ];

  nativeBuildInputs = [
    docbook-xsl-nons # for goa-daemon.xml
    gettext
    gi-docgen
    gobject-introspection
    libxslt
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook4
  ];

  buildInputs = [
    dbus
    gcr_4
    glib
    glib-networking
    gtk4
    libadwaita
    gvfs # OwnCloud, Google Drive
    json-glib
    libkrb5
    librest_1_0
    libxml2
    libsecret
    libsoup_3
  ]
  ++ lib.optionals enableBackend [
    keyutils
  ];

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc" "$devdoc"
  '';

  separateDebugInfo = true;

  passthru = {
    updateScript = gnome.updateScript {
      versionPolicy = "odd-unstable";
      packageName = "gnome-online-accounts";
    };
  };

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/GNOME/gnome-online-accounts";
    description = "Single sign-on framework for GNOME";
    platforms = platforms.unix;
    license = licenses.lgpl2Plus;
    teams = [ teams.gnome ];
  };
})
