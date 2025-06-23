{
  lib,
  fetchFromGitLab,
  glib,
  gtk3,
  meson,
  ninja,
  pkg-config,
  gobject-introspection,
  vala,
  stdenv,
  wrapGAppsHook3,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "appmenu-glib-translator";
  version = "25.04";

  src = fetchFromGitLab {
    owner = "vala-panel-project";
    repo = "vala-panel-appmenu";
    tag = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-v5J3nwViNiSKRPdJr+lhNUdKaPG82fShPDlnmix5tlY=";
  };

  sourceRoot = "source/subprojects/appmenu-glib-translator";

  nativeBuildInputs = [
    meson
    ninja

    pkg-config
    wrapGAppsHook3
    vala
  ];

  buildInputs = [
    glib
    gobject-introspection
    gtk3
  ];

  meta = {
    description = "GTK module that strips menus from all GTK programs, converts to MenuModel and sends to AppMenu";
    homepage = "https://gitlab.com/vala-panel-project/vala-panel-appmenu/-/tree/${finalAttrs.version}/subprojects/appmenu-gtk-module";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ perchun ];
    platforms = lib.platforms.linux;
  };
})
