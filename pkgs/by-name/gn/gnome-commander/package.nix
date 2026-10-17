{
  lib,
  stdenv,
  fetchFromGitLab,
  rustPlatform,
  meson,
  ninja,
  pkg-config,
  cargo,
  rustc,
  glib,
  gettext,
  itstool,
  gobject-introspection,
  wrapGAppsHook4,
  desktop-file-utils,
  gtk4,
  vte-gtk4,
  gdk-pixbuf,
  exiv2,
  libgsf,
  taglib,
  poppler,
  xdg-terminal-exec,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-commander";
  version = "2.0.3";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "gnome-commander";
    tag = finalAttrs.version;
    hash = "sha256-oul7NQ5LJkzCorkIIsmzriJlVU3pffOIKsQ3iEn3+90=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-lLyDzGn3+C7qAuq41Ncx+B4+mOzy+r99ZN5taVcgUR0=";
  };

  postPatch = ''
    # hard-coded schema path
    substituteInPlace plugins/fileroller/file-roller-plugin.cc \
      --replace-fail \
        '/share/glib-2.0/schemas' \
        '/share/gsettings-schemas/${finalAttrs.finalPackage.name}/glib-2.0/schemas'
  '';

  strictDeps = true;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    rustPlatform.cargoSetupHook
    cargo
    rustc
    glib
    gettext
    itstool
    gobject-introspection
    wrapGAppsHook4
    desktop-file-utils
  ];

  buildInputs = [
    glib
    gtk4
    vte-gtk4
    gdk-pixbuf
    exiv2
    libgsf
    taglib
    poppler
  ];

  # The `terminal-cmd`/`terminal-exec-cmd` defaults invoke xdg-terminal-exec by
  # name. Put it on PATH rather than substituting a store path into the gschema:
  # the options dialog writes every command back to dconf verbatim, which would
  # pin a store path that goes stale on the next garbage collection.
  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : ${lib.makeBinPath [ xdg-terminal-exec ]}
    )
  '';

  # These tests need a display to run
  doCheck = false;

  meta = {
    description = "Fast and powerful twin-panel file manager for the Linux desktop";
    homepage = "https://gnome.pages.gitlab.gnome.org/gnome-commander/";
    license = lib.licenses.gpl3Plus;
    mainProgram = "gnome-commander";
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.linux;
  };
})
