{
  clangStdenv,
  cmake,
  cmark,
  curl,
  fetchFromGitHub,
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
  libxcb,
  libXrandr,
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
  version = "1.3.15.3";

  srcs = [
    (fetchFromGitHub {
      name = "aseprite-source";
      owner = "aseprite";
      repo = "aseprite";
      tag = "v${finalAttrs.version}";
      fetchSubmodules = true;
      hash = "sha256-/06p/eZcyTGfzhVix+2TgiwfXIGhTIWviUmopnuKW8c=";
    })

    # Translation strings
    (fetchFromGitHub {
      name = "aseprite-strings";
      owner = "aseprite";
      repo = "strings";
      rev = "a8d05093dfa21398210168f4f08fc9449350c01c";
      hash = "sha256-Ge6gRwVCaWwmVegiJmINEHirvgTJIG3DW7T8WEQLBao=";
    })
  ];

  # Sets the main build directory to "aseprite-source" since multiple sources are fetched.
  sourceRoot = "aseprite-source";

  # Translation files are copied without overwriting existing ones to preserve the potentially more up-to-date English file from the main source.
  postUnpack = ''
    cp --no-clobber $PWD/aseprite-strings/* ./aseprite-source/data/strings
  '';

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
    libxcb
    libXrandr
    pcre2
    pixman
    skia-aseprite
    tinyxml-2
    zlib
  ];

  patches = [
    ./shared-fmt.patch
    ./shared-libwebp.patch
    ./shared-skia-deps.patch
    ./shared-libjpeg-turbo.patch
  ];

  postPatch = ''
    substituteInPlace src/ver/CMakeLists.txt \
      --replace-fail '"1.x-dev"' '"${finalAttrs.version}"'
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
    "-DUSE_SHARED_LIBPNG=ON"
    "-DUSE_SHARED_PIXMAN=ON"
    "-DUSE_SHARED_TINYXML=OFF"
    "-DUSE_SHARED_WEBP=ON"
    "-DUSE_SHARED_ZLIB=ON"
    # Disable libarchive programs.
    "-DENABLE_CAT=OFF"
    "-DENABLE_CPIO=OFF"
    "-DENABLE_TAR=OFF"
    # UI backend.
    "-DLAF_BACKEND=skia"
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
    mainProgram = "aseprite";
  };
})
