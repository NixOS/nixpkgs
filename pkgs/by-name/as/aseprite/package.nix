{
  clangStdenv,
  cmake,
  cmark,
  curl,
  fetchFromGitHub,
  fetchpatch,
  fmt,
  fontconfig,
  freetype,
  giflib,
  gitUpdater,
  glib,
  harfbuzzFull,
  lib,
  libGL,
  libjpeg,
  libpng,
  libwebp,
  libX11,
  libXcursor,
  libXext,
  libXi,
  libXxf86vm,
  ninja,
  pcre2,
  pixman,
  pkg-config,
  skia-aseprite,
  tinyxml-2,
  zlib,
}:

clangStdenv.mkDerivation (finalAttrs: {
  pname = "aseprite";
  version = "1.3.7";

  src = fetchFromGitHub {
    owner = "aseprite";
    repo = "aseprite";
    rev = "v" + finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-75kYJXmyags0cW2D5Ksq1uUrFSCAkFOdmn7Ya/6jLXc=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ];

  buildInputs = [
    cmark
    curl
    fmt
    fontconfig
    freetype
    giflib
    glib
    harfbuzzFull
    libGL
    libjpeg
    libpng
    libwebp
    libX11
    libXcursor
    libXext
    libXi
    libXxf86vm
    pcre2
    pixman
    skia-aseprite
    tinyxml-2
    zlib
  ];

  patches = [
    # https://github.com/aseprite/aseprite/issues/4486
    # FIXME: remove on next release.
    (fetchpatch {
      name = "ENABLE_UPDATER-fix.patch";
      url = "https://github.com/aseprite/aseprite/commit/8fce589.patch";
      hash = "sha256-DbL6kK//gQXbsXEn/t+KTuoM7E9ocPAsVqEO+lYrka4=";
    })
    ./shared-fmt.patch
    ./shared-libwebp.patch
    ./shared-skia-deps.patch
  ];

  postPatch =
    let
      # Translation strings
      strings = fetchFromGitHub {
        owner = "aseprite";
        repo = "strings";
        rev = "e18a09fefbb6cd904e506183d5fbe08558a52ed4";
        hash = "sha256-GyCCxbhgf0vST20EH/+KkNLrF+U9Xzgpxlao8s925PQ=";
      };
    in
    ''
      sed -i src/ver/CMakeLists.txt -e "s-set(VERSION \".*\")-set(VERSION \"$version\")-"
      rm -rf data/strings
      cp -r ${strings} data/strings
    '';

  cmakeFlags = [
    "-DENABLE_DESKTOP_INTEGRATION=ON"
    "-DENABLE_UPDATER=OFF"
    "-DUSE_SHARED_CMARK=ON"
    "-DUSE_SHARED_CURL=ON"
    "-DUSE_SHARED_FMT=ON"
    "-DUSE_SHARED_FREETYPE=ON"
    "-DUSE_SHARED_GIFLIB=ON"
    "-DUSE_SHARED_HARFBUZZ=ON"
    "-DUSE_SHARED_JPEGLIB=ON"
    "-DUSE_SHARED_LIBPNG=ON"
    "-DUSE_SHARED_LIBWEBP=ON"
    "-DUSE_SHARED_PIXMAN=ON"
    "-DUSE_SHARED_TINYXML=ON"
    "-DUSE_SHARED_WEBP=ON"
    "-DUSE_SHARED_ZLIB=ON"
    # Disable libarchive programs.
    "-DENABLE_CAT=OFF"
    "-DENABLE_CPIO=OFF"
    "-DENABLE_TAR=OFF"
    # UI backend.
    "-DLAF_OS_BACKEND=skia"
    "-DLAF_WITH_EXAMPLES=OFF"
    "-DSKIA_DIR=${skia-aseprite}"
    "-DSKIA_LIBRARY_DIR=${skia-aseprite}/lib"
  ];

  postInstall = ''
    # Install desktop icons.
    src="$out/share/aseprite/data/icons"
    for size in 16 32 48 64 128 256; do
      dst="$out"/share/icons/hicolor/"$size"x"$size"
      install -Dm644 "$src"/ase"$size".png "$dst"/apps/aseprite.png
      install -Dm644 "$src"/doc"$size".png "$dst"/mimetypes/image-x-aseprite.png
    done
    # Delete unneeded artifacts of bundled libraries.
    rm -rf "$out"/{include,lib,man}
  '';

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    homepage = "https://www.aseprite.org/";
    description = "Animated sprite editor & pixel art tool";
    license = lib.licenses.unfree;
    longDescription = ''
      Aseprite is a program to create animated sprites. Its main features are:

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
    maintainers = with lib.maintainers; [
      orivej
    ];
    platforms = lib.platforms.linux;
  };
})
