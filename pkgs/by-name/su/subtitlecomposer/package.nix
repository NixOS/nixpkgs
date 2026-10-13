{
  lib,
  fetchFromGitLab,
  cmake,
  pkg-config,
  ffmpeg_7,
  openal,
  stdenv,
  qt6,
  kdePackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "subtitlecomposer";
  version = "0.8.2";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "multimedia";
    repo = "subtitlecomposer";
    rev = "v${finalAttrs.version}";
    hash = "sha256-zGbI960NerlOEUvhOLm+lEJdbhj8VFUfm8pkOYGRcGw=";
  };

  cmakeFlags = [
    "-DQT_MAJOR_VERSION=6"
    "-DQT_FIND_PRIVATE_MODULES=ON"
  ];

  nativeBuildInputs = [
    cmake
    kdePackages.extra-cmake-modules
    pkg-config
    qt6.wrapQtAppsHook
  ];
  buildInputs = [
    ffmpeg_7
    openal
    qt6.qt5compat
  ]
  ++ (with kdePackages; [
    kcodecs
    kconfig
    kconfigwidgets
    kcoreaddons
    ki18n
    kio
    ktextwidgets
    kwidgetsaddons
    kxmlgui
    sonnet
  ]);

  meta = {
    homepage = "https://apps.kde.org/subtitlecomposer";
    description = "Open source text-based subtitle editor";
    longDescription = ''
      An open source text-based subtitle editor that supports basic and
      advanced editing operations, aiming to become an improved version of
      Subtitle Workshop for every platform supported by Plasma Frameworks.
    '';
    changelog = "https://invent.kde.org/multimedia/subtitlecomposer/-/blob/master/ChangeLog";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ kugland ];
    mainProgram = "subtitlecomposer";
    platforms = with lib.platforms; linux ++ freebsd ++ windows;
  };
})
