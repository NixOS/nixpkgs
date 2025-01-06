{
  stdenv,
  lib,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  python3,
  libxml2,
  gitUpdater,
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
  version = "3.54.2";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "gnome-terminal";
    rev = finalAttrs.version;
    hash = "sha256-81dOdmIwa3OmuUTciTlearqic6bFMfiX1nvoIxJCt/M=";
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
    pcre2
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
  ];

  postPatch = ''
    patchShebangs \
      data/icons/meson_updateiconcache.py \
      data/meson_desktopfile.py \
      data/meson_metainfofile.py \
      src/meson_compileschemas.py
  '';

  passthru = {
    updateScript = gitUpdater {
      odd-unstable = true;
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
    maintainers = teams.gnome.members;
  };
})
