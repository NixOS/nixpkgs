{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  cmake,
  qt5,
  qt6,
  wayland,
  nix-update-script,
  useQt6 ? false,

  # Shadows support on Qt5 requires the feature backported from Qt6:
  # https://src.fedoraproject.org/rpms/qt5-qtwayland/blob/rawhide/f/qtwayland-decoration-support-backports-from-qt6.patch
  qt5ShadowsSupport ? false,
}:

let
  qt = if useQt6 then qt6 else qt5;
  qtVersion = if useQt6 then "6" else "5";

in
stdenv.mkDerivation (finalAttrs: {
  pname = "qadwaitadecorations";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "FedoraQt";
    repo = "QAdwaitaDecorations";
    rev = finalAttrs.version;
    hash = "sha256-Zg2G3vuRD/kK5C2fFq6Cft218uFyBvfXtO1DHKQECFQ=";
  };

  patches = [
    (fetchpatch2 {
      # https://github.com/FedoraQt/QAdwaitaDecorations/pull/88
      name = "Fix build with Qt 6.10";
      url = "https://github.com/FedoraQt/QAdwaitaDecorations/commit/e6da80a440218b87e441c8a698014ef3962af98b.patch?full_index=1";
      hash = "sha256-7ZmceoOzUDHvvCX+8SwuX+DIi65d6hYIYfpikMiN0wM=";
    })
  ];

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
  ]
  ++ lib.optional useQt6 "-DUSE_QT6=true"
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
