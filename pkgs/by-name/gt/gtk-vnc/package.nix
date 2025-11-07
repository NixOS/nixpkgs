{
  lib,
  stdenv,
  fetchurl,
  meson,
  ninja,
  gobject-introspection,
  gnutls,
  cairo,
  glib,
  pkg-config,
  cyrus_sasl,
  pulseaudioSupport ? stdenv.hostPlatform.isLinux,
  libpulseaudio,
  gmp,
  gtk3,
  vala,
  gettext,
  perl,
  python3,
  gi-docgen,
  gnome,
  gdk-pixbuf,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gtk-vnc";
  version = "1.5.0";

  outputs = [
    "out"
    "bin"
    "man"
    "dev"
    "devdoc"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/gtk-vnc/${lib.versions.majorMinor finalAttrs.version}/gtk-vnc-${finalAttrs.version}.tar.xz";
    sha256 = "wL60dHUorZMdpDrMVnxqAZD3/GJEZVce2czs4Cw03SM=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection
    vala
    gettext
    perl # for pod2man
    python3
    gi-docgen
  ];

  buildInputs = [
    gnutls
    cairo
    gdk-pixbuf
    zlib
    glib
    gmp
    cyrus_sasl
    gtk3
  ]
  ++ lib.optionals pulseaudioSupport [
    libpulseaudio
  ];

  mesonFlags = lib.optionals (!pulseaudioSupport) [
    "-Dpulseaudio=disabled"
  ];

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc" "$devdoc"
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gtk-vnc";
      versionPolicy = "none";
    };
  };

  meta = with lib; {
    description = "GTK VNC widget";
    homepage = "https://gitlab.gnome.org/GNOME/gtk-vnc";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [
      raskin
      offline
    ];
    platforms = platforms.unix;
    mainProgram = "gvnccapture";
  };
})
