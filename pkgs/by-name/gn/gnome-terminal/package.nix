{
  stdenv,
  lib,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  python3,
  libxml2,
  gnome,
  nautilus,
  glib,
  gtk4,
  gtk3,
  libhandy,
  gsettings-desktop-schemas,
  vte,
  gettext,
  which,
  libuuid,
  vala,
  desktop-file-utils,
  itstool,
  wrapGAppsHook3,
  pcre2,
  libxslt,
  docbook-xsl-nons,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-terminal";
  version = "3.56.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-terminal/${lib.versions.majorMinor finalAttrs.version}/gnome-terminal-${finalAttrs.version}.tar.xz";
    hash = "sha256-ojB1PlC9Qx27EwDhV7/XMXMA4lIm/zCJMxY2OhOGT/g=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    itstool
    which
    libxml2
    libxslt
    glib # for glib-compile-schemas
    docbook-xsl-nons
    vala
    desktop-file-utils
    wrapGAppsHook3
    python3
  ];

  buildInputs = [
    glib
    gtk4
    gtk3
    libhandy
    gsettings-desktop-schemas
    vte
    libuuid
    nautilus # For extension
    pcre2
  ];

  postPatch = ''
    patchShebangs \
      data/icons/meson_updateiconcache.py \
      data/meson_desktopfile.py \
      data/meson_metainfofile.py \
      src/meson_compileschemas.py
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gnome-terminal";
      versionPolicy = "odd-unstable";
    };

    tests = {
      test = nixosTests.terminal-emulators.gnome-terminal;
    };
  };

  meta = with lib; {
    description = "GNOME Terminal Emulator";
    mainProgram = "gnome-terminal";
    homepage = "https://gitlab.gnome.org/GNOME/gnome-terminal";
    platforms = platforms.linux;
    license = licenses.gpl3Plus;
    teams = [ teams.gnome ];
  };
})
