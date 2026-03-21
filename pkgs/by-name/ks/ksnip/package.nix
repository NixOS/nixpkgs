{
  stdenv,
  lib,
  cmake,
  fetchFromGitHub,
  fetchpatch,
  libsForQt5,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ksnip";
  version = "1.10.1";

  src = fetchFromGitHub {
    owner = "ksnip";
    repo = "ksnip";
    tag = "v${finalAttrs.version}";
    hash = "sha256-n7YwDXd73hyrzb6L8utZFuHh9HnjVtkU6CC4jfWPj/I=";
  };

  patches = [
    # Fix build with latest kImageAnnotator
    (fetchpatch {
      url = "https://github.com/ksnip/ksnip/commit/76f4b381971eead6ff31b8bf3bb64bb5717469c3.patch";
      hash = "sha256-JWoI974qDNZIzr/8oksI8m6g3XNWEaQRGsqSfvQrmao=";
    })
  ];

  nativeBuildInputs = [
    cmake
  ]
  ++ (with libsForQt5; [
    extra-cmake-modules
    wrapQtAppsHook
    qttools
  ]);

  buildInputs = with libsForQt5; [
    kcolorpicker
    kimageannotator
    qtsvg
    qtx11extras
  ];

  meta = {
    homepage = "https://github.com/ksnip/ksnip";
    description = "Cross-platform screenshot tool with many annotation features";
    longDescription = ''
      Features:

      - Supports Linux (X11, Plasma Wayland, GNOME Wayland and xdg-desktop-portal Wayland), Windows and macOS.
      - Screenshot of a custom rectangular area that can be drawn with mouse cursor.
      - Screenshot of last selected rectangular area without selecting again.
      - Screenshot of the screen/monitor where the mouse cursor is currently located.
      - Screenshot of full-screen, including all screens/monitors.
      - Screenshot of window that currently has focus.
      - Screenshot of window under mouse cursor.
      - Screenshot with or without mouse cursor.
      - Capture mouse cursor as annotation item that can be moved and deleted.
      - Customizable capture delay for all capture options.
      - Upload screenshots directly to imgur.com in anonymous or user mode.
      - Upload screenshots via custom user defined scripts.
      - Command-line support, for capturing screenshots and saving to default location, filename and format.
      - Filename wildcards for Year ($Y), Month ($M), Day ($D), Time ($T) and Counter (multiple # characters for number with zero-leading padding).
      - Print screenshot or save it to PDF/PS.
      - Annotate screenshots with pen, marker, rectangles, ellipses, texts and other tools.
      - Annotate screenshots with stickers and add custom stickers.
      - Obfuscate image regions with blur and pixelate.
      - Add effects to image (Drop Shadow, Grayscale, invert color or Border).
      - Add watermarks to captured images.
      - Global hotkeys for capturing screenshots (currently only for Windows and X11).
      - Tabs for screenshots and images.
      - Open existing images via dialog, drag-and-drop or paste from clipboard.
      - Run as single instance application (secondary instances send cli parameter to primary instance).
      - Pin screenshots in frameless windows that stay atop other windows.
      - User-defined actions for taking screenshot and post-processing.
      - Many configuration options.
    '';
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "ksnip";
  };
})
