{
  lib,
  fetchFromGitLab,
  cmake,
  extra-cmake-modules,
  ffmpeg_6,
  openal,
  stdenv,
  libsForQt5,
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

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    libsForQt5.wrapQtAppsHook
  ];
  buildInputs = [
    ffmpeg_6
    openal
  ]
  ++ (with libsForQt5; [
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
