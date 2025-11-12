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
  version = "3.58.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-terminal/${lib.versions.majorMinor finalAttrs.version}/gnome-terminal-${finalAttrs.version}.tar.xz";
    hash = "sha256-B+vHrxNRa+Wzd3f1INJkCzMSBiDpm7sF3upfgoD9ac4=";
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
