{ lib
, stdenv
, fetchFromGitHub

, cmake
, pkg-config
, ninja
, gtest

, curl
, freetype
, giflib
, libjpeg
, libpng
, libwebp
, pixman
, tinyxml
, zlib
, SDL2
, SDL2_image
, lua
, AppKit
, Cocoa
, Foundation

, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "libresprite";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "LibreSprite";
    repo = "LibreSprite";
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "sha256-d8GmVHYomDb74iSeEhJEVTHvbiVXggXg7xSqIKCUSzY=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    ninja
    gtest
  ];

  buildInputs = [
    curl
    freetype
    giflib
    libjpeg
    libpng
    libwebp
    pixman
    tinyxml
    zlib
    SDL2
    SDL2_image
    lua
    # no v8 due to missing libplatform and libbase
  ] ++ lib.optionals stdenv.isDarwin [
    AppKit
    Cocoa
    Foundation
  ];

  cmakeFlags = [
    "-DWITH_DESKTOP_INTEGRATION=ON"
    "-DWITH_WEBP_SUPPORT=ON"
  ];

  hardeningDisable = lib.optional stdenv.isDarwin "format";

  # Install mime icons. Note that the mimetype is still "x-aseprite"
  postInstall = ''
    src="$out/share/libresprite/data/icons"
    for size in 16 32 48 64; do
      dst="$out"/share/icons/hicolor/"$size"x"$size"
      install -Dm644 "$src"/doc"$size".png "$dst"/mimetypes/aseprite.png
    done
  '';

  passthru.tests = {
    libresprite-can-open-png = nixosTests.libresprite;
  };

  meta = with lib; {
    homepage = "https://libresprite.github.io/";
    description = "Animated sprite editor & pixel art tool, fork of Aseprite";
    license = licenses.gpl2Only;
    longDescription =
      ''LibreSprite is a program to create animated sprites. Its main features are:

          - Sprites are composed by layers & frames (as separated concepts).
          - Supported color modes: RGBA, Indexed (palettes up to 256 colors), and Grayscale.
          - Load/save sequence of PNG files and GIF animations (and FLC, FLI, JPG, BMP, PCX, TGA).
          - Export/import animations to/from Sprite Sheets.
          - Tiled drawing mode, useful to draw patterns and textures.
          - Undo/Redo for every operation.
          - Real-time animation preview.
          - Multiple editors support.
          - Pixel-art specific tools like filled Contour, Polygon, Shading mode, etc.
          - Onion skinning.
      '';
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.all;
    # https://github.com/LibreSprite/LibreSprite/issues/308
    broken = stdenv.isDarwin;
  };
}
