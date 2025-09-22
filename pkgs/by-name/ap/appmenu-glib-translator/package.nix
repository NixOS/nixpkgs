{
  lib,
  fetchFromGitLab,
  stdenv,
  glib,
  gobject-introspection,
  meson,
  ninja,
  pkg-config,
  vala,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "appmenu-glib-translator";
  version = "25.04";

  src = fetchFromGitLab {
    owner = "vala-panel-project";
    repo = "vala-panel-appmenu";
    tag = finalAttrs.version;
    hash = "sha256-v5J3nwViNiSKRPdJr+lhNUdKaPG82fShPDlnmix5tlY=";
  };

  sourceRoot = "source/subprojects/appmenu-glib-translator";

  nativeBuildInputs = [
    meson
    ninja

    pkg-config
    gobject-introspection
    vala
  ];

  propagatedBuildInputs = [ glib ];

  meta = {
    description = "Library for translating from DBusMenu to GMenuModel";
    homepage = "https://gitlab.com/vala-panel-project/vala-panel-appmenu/-/tree/${finalAttrs.version}/subprojects/appmenu-glib-translator";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ perchun ];
    platforms = lib.platforms.linux;
  };
})
