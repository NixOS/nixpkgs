{
  lib,
  stdenv,
  fetchFromGitHub,
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
  pname = "qwhitesurgtkdecorations";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "FengZhongShaoNian";
    repo = "QWhiteSurGtkDecorations";
    rev = finalAttrs.version;
    hash = "sha256-dMwaLHAbpTBP8UvUvrW+CRBzgr11o+OAbsTW7AcnZsI=";
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

  cmakeFlags =
    [
      "-DQT_PLUGINS_DIR=${placeholder "out"}/${qt.qtbase.qtPluginPrefix}"
    ]
    ++ lib.optional useQt6 "-DUSE_QT6=true"
    ++ lib.optional qt5ShadowsSupport "-DHAS_QT6_SUPPORT=true";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Qt${qtVersion} decoration plugin implementing WhiteSurGTK-like client-side decorations. This project is modified based on the QAdwaitaDecorations project. Some of the icon resources used in this project come from WhiteSur-gtk-theme.";
    homepage = "https://github.com/FengZhongShaoNian/QWhiteSurGtkDecorations";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ sjhaleprogrammer ];
    platforms = lib.platforms.linux;
  };
})
