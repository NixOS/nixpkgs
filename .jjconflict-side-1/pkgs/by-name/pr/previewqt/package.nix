{
  lib,
  cmake,
  exiv2,
  extra-cmake-modules,
  fetchFromGitLab,
  imagemagick,
  libarchive,
  libdevil,
  libraw,
  mpv,
  pkg-config,
  qt6Packages,
  resvg,
  stdenv,
  vips,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "previewqt";
  version = "3.0";

  src = fetchFromGitLab {
    name = "previewqt-sources-${finalAttrs.version}";
    owner = "lspies";
    repo = "previewqt";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-cDtqgezKGgSdhw8x1mM4cZ0H3SfUPEyWP6rRD+kRwXc=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6Packages.wrapQtAppsHook
  ];

  buildInputs =
    [
      exiv2
      extra-cmake-modules
      imagemagick
      libarchive
      libdevil
      libraw
      mpv
      resvg
      vips
    ]
    ++ [
      qt6Packages.poppler
      qt6Packages.qtmultimedia
      qt6Packages.qtquick3d
      qt6Packages.qtsvg
      qt6Packages.qttools
      qt6Packages.qtwebengine
    ];

  strictDeps = true;

  meta = {
    homepage = "https://previewqt.org/";
    description = "Qt-based file previewer";
    longDescription = ''
      PhotoQt is an image viewer that provides a simple and uncluttered
      interface. Yet, hidden beneath the surface awaits a large array of
      features. Here are some of its main features (not an exhaustive
      list). Suggestions for new features are always welcome.

      - Support of ImageMagick/GraphicsMagick, Libraw, FreeImage, DevIL,
        libvips, Poppler, libarchive, and video files.
      - Touchscreen support
      - Support for Motion Photos and Apple Live Photos
      - Support for (partial) photo spheres and 360 degree panoramas using
        equirectangular projection
      - Explore images on an interactive map according to their embedded GPS
        location
      - Chromecast support
      - Basic image manipulations
      - Convert images between formats
      - Keyboard and mouse shortcuts
      - Upload images directly to imgur.com
      - Set image as wallpaper directly from inside PhotoQt
      - Slideshow feature
      - Display Exif information (including tagging of faces)
      - Detect and display bar codes and QR codes in images
      - Thumbnail Cache
      - System Tray Usage
      - Command Line Options
      - Several translations available (help wanted)
      - and much more...
    '';
    changelog = "https://gitlab.com/lspies/previewqt/-/blob/v${finalAttrs.version}/CHANGELOG";
    license = lib.licenses.gpl2Plus;
    mainProgram = "previewqt";
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.linux;
  };
})
