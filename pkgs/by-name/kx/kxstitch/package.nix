{
  stdenv,
  lib,
  fetchgit,
  cmake,
  imagemagick,
  kdePackages,
  pkg-config,
}:

stdenv.mkDerivation {
  pname = "kxstitch";
  version = "unstable-2025-08-16";

  src = fetchgit {
    url = "https://invent.kde.org/graphics/kxstitch.git";
    rev = "bfe934ffc2c2dfa1cc554bc4483a3285b027b00c";
    hash = "sha256-B81nwInFWcQVDJU6VINII8crVPtV5zYBXADVVe+wCu4=";
  };

  buildInputs = with kdePackages; [
    qtbase
    kconfig
    kconfigwidgets
    kcompletion
    kio
    ktextwidgets
    kxmlgui
  ];

  nativeBuildInputs = [
    cmake
    imagemagick
    pkg-config
  ]
  ++ (with kdePackages; [
    extra-cmake-modules
    wrapQtAppsHook
  ]);

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
