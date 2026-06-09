{
  stdenv,
  lib,
  fetchurl,
  asciidoc,
  docbook-xsl-nons,
  docbook_xml_dtd_45,
  gettext,
  itstool,
  libxslt,
  gexiv2_0_16,
  tinysparql,
  meson,
  mesonEmulatorHook,
  ninja,
  pkg-config,
  vala,
  wrapGAppsNoGuiHook,
  bzip2,
  dbus,
  exempi,
  ffmpeg,
  giflib,
  glib,
  gobject-introspection,
  gnome,
  icu,
  json-glib,
  libcue,
  libgsf,
  libgxps,
  libjpeg,
  libosinfo,
  libpng,
  libseccomp,
  libtiff,
  libuuid,
  libwebp,
  libxml2,
  libzip,
  poppler,
  systemd,
  taglib,
  upower,
  totem-pl-parser,
  e2fsprogs,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "localsearch";
  version = "3.11.1";

  src = fetchurl {
    url = "mirror://gnome/sources/localsearch/${lib.versions.majorMinor finalAttrs.version}/localsearch-${finalAttrs.version}.tar.xz";
    hash = "sha256-ezmmwoqKzysXLxWy+17nx6N2TER8L0oUyqI5t+vmGUI=";
  };

  patches = [
    ./tracker-landlock-nix-store-permission.patch
  ];

  nativeBuildInputs = [
    asciidoc
    docbook-xsl-nons
    docbook_xml_dtd_45
    gettext
    glib
    gobject-introspection
    itstool
    libxslt
    meson
    ninja
    pkg-config
    vala
    wrapGAppsNoGuiHook
  ]
  ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    mesonEmulatorHook
  ];

  # TODO: add libenca, libosinfo
  buildInputs = [
    bzip2
    dbus
    exempi
    ffmpeg
    giflib
    gexiv2_0_16
    totem-pl-parser
    tinysparql
    icu
    json-glib
    libcue
    libgsf
    libgxps
    libjpeg
    libosinfo
    libpng
    libtiff
    libuuid
    libwebp
    libxml2
    libzip
    poppler
    taglib
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libseccomp
    systemd
    upower
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    e2fsprogs
  ];

  mesonFlags = [
    # TODO: tests do not like our sandbox
    "-Dfunctional_tests=false"
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isLinux) [
    "-Dbattery_detection=none"
    "-Dnetwork_manager=disabled"
    "-Dsystemd_user_services=false"
  ];

  postInstall = ''
    glib-compile-schemas "$out/share/glib-2.0/schemas"
  '';

  passthru = {
    updateScript = gnome.updateScript { packageName = "localsearch"; };
  };

  meta = {
    homepage = "https://gitlab.gnome.org/GNOME/localsearch";
    description = "Desktop-neutral user information store, search tool and indexer";
    teams = [ lib.teams.gnome ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    mainProgram = "localsearch";
  };
})
