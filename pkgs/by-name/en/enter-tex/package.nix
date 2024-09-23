{
  stdenv,
  lib,
  fetchurl,
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
  gnome,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "enter-tex";
  version = "3.47.0";

  src = fetchurl {
    url = "mirror://gnome/sources/enter-tex/${lib.versions.majorMinor finalAttrs.version}/enter-tex-${finalAttrs.version}.tar.xz";
    hash = "sha256-oIyuySdcCruVNWdN9bnBa5KxSWjNIZFtb/wvoMud12o=";
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
    # https://gitlab.gnome.org/swilmet/enter-tex/-/blob/3.47.0/docs/more-information.md#install-procedure
    ninja src/gtex/Gtex-1.gir
  '';

  doCheck = true;

  passthru.updateScript = gnome.updateScript {
    packageName = "enter-tex";
  };

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/swilmet/enter-tex";
    description = "LaTeX editor for the GNOME desktop";
    maintainers = with maintainers; [
      manveru
      bobby285271
    ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    mainProgram = "enter-tex";
  };
})
