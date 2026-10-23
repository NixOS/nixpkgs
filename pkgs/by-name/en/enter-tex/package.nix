{
  stdenv,
  lib,
  fetchFromGitLab,
  desktop-file-utils,
  docbook-xsl-nons,
  gettext,
  gobject-introspection,
  gtk-doc,
  itstool,
  meson,
  ninja,
  pkg-config,
  vala,
  wrapGAppsHook3,
  dconf,
  glib,
  gsettings-desktop-schemas,
  gspell,
  libgedit-amtk,
  libgedit-gtksourceview,
  libgedit-tepl,
  libgee,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "enter-tex";
  version = "3.49.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    group = "World";
    owner = "gedit";
    repo = "enter-tex";
    tag = finalAttrs.version;
    hash = "sha256-CRxWN4eeB9uDdLtRh3aXHoN+gSlXSPDftGHcPtjgAzU=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    docbook-xsl-nons
    gettext
    gobject-introspection
    gtk-doc
    itstool
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook3
  ];

  buildInputs = [
    dconf
    glib
    gsettings-desktop-schemas
    gspell
    libgedit-amtk
    libgedit-gtksourceview
    libgedit-tepl
    libgee
  ];

  preBuild = ''
    # Workaround the use case of C code mixed with Vala code.
    # https://gitlab.gnome.org/World/gedit/enter-tex/-/blob/3.48.0/docs/more-information.md#install-procedure
    ninja src/gtex/Gtex-1.gir
  '';

  doCheck = true;

  passthru.updateScript = gitUpdater { };

  meta = {
    homepage = "https://gitlab.gnome.org/World/gedit/enter-tex";
    description = "LaTeX editor for the GNOME desktop";
    maintainers = with lib.maintainers; [
      bobby285271
    ];
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "enter-tex";
  };
})
