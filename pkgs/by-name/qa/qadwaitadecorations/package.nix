{ lib
, stdenv
, fetchFromGitHub
, cmake
, qt5
, qt6
, wayland
, nix-update-script
, useQt6 ? false

# Shadows support on Qt5 requires the feature backported from Qt6:
# https://src.fedoraproject.org/rpms/qt5-qtwayland/blob/rawhide/f/qtwayland-decoration-support-backports-from-qt6.patch
, qt5ShadowsSupport ? false
}:

let
  qt = if useQt6 then qt6 else qt5;
  qtVersion = if useQt6 then "6" else "5";

in stdenv.mkDerivation (finalAttrs: {
  pname = "qadwaitadecorations";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "FedoraQt";
    repo = "QAdwaitaDecorations";
    rev = finalAttrs.version;
    hash = "sha256-9uK2ojukuwzOz/genWiCch4c3pL5qEfyy8ERpFxS8/8=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = with qt; [
    qtbase
    qtsvg
    qtwayland
    wayland
  ];

  dontWrapQtApps = true;

  cmakeFlags = [
    "-DQT_PLUGINS_DIR=${placeholder "out"}/${qt.qtbase.qtPluginPrefix}"
  ] ++ lib.optional useQt6 "-DUSE_QT6=true"
    ++ lib.optional qt5ShadowsSupport "-DHAS_QT6_SUPPORT=true";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Qt${qtVersion} Wayland decoration plugin using libadwaita style";
    homepage = "https://github.com/FedoraQt/QAdwaitaDecorations";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ samlukeyes123 ];
    platforms = lib.platforms.linux;
  };
})
