{
  stdenv,
  lib,
  fetchgit,
  cmake,
  extra-cmake-modules,
  imagemagick,
  libsForQt5,
}:

stdenv.mkDerivation {
  pname = "kxstitch";
  version = "unstable-2023-12-31";

  src = fetchgit {
    url = "https://invent.kde.org/graphics/kxstitch.git";
    rev = "4bb575dcb89e3c997e67409c8833e675962e101a";
    hash = "sha256-pi+RpuT8YQYp1ogGtIgXpTPdYSFk19TUHTHDVyOcrMI=";
  };

  buildInputs = with libsForQt5; [
    qtbase
    kconfig
    kconfigwidgets
    kcompletion
    kio
  ];

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    imagemagick
    libsForQt5.wrapQtAppsHook
  ];

  postInstall = ''
    install -D $src/org.kde.kxstitch.desktop $out/share/applications/org.kde.kxstitch.desktop

    for size in 16 22 32 48 64 128 256; do
      install -D $src/icons/app/$size-apps-kxstitch.png $out/share/icons/hicolor/$size\x$size/kxstitch.png
    done
  '';

  meta = {
    homepage = "https://invent.kde.org/graphics/kxstitch";
    description = "Cross stitch pattern and chart creation";
    maintainers = with lib.maintainers; [ eliandoran ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "kxstitch";
  };
}
