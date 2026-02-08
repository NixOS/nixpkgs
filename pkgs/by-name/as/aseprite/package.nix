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
  libicns,
  lib,
  libGL,
  libjpeg,
  libpng,
  libwebp,
  libx11,
  libxcursor,
  libxext,
  libxi,
  libxxf86vm,
  libxcb,
  libxrandr,
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
  version = "1.3.16.1";

  srcs = [
    (fetchFromGitHub {
      name = "aseprite-source";
      owner = "aseprite";
      repo = "aseprite";
      tag = "v${finalAttrs.version}";
      fetchSubmodules = true;
      hash = "sha256-s2lWg5udg/8pXjOcj2nXDS2uE3urkg1iC0Div7wkxUY=";
    })

    # Translation strings
    (fetchFromGitHub {
      name = "aseprite-strings";
      owner = "aseprite";
      repo = "strings";
      rev = "0f49265d7e7aea4b862b7d1e670ed969e8a469b8";
      hash = "sha256-S3YkWA5ECvyyqGvojDhIZci04CTjbJzTQiJ5FZsB4lU=";
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
  ]
  ++ lib.optionals clangStdenv.hostPlatform.isDarwin [
    libicns
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
    libx11
    libxcursor
    libxext
    libxi
    libxxf86vm
    libxcb
    libxrandr
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

    # Fix build on Darwin with `-Werror=format-security`
    # (NSLog requires a string-literal format)
    substituteInPlace laf/os/osx/logger.mm \
      --replace-fail 'NSLog([NSString stringWithUTF8String:error]);' 'NSLog(@"%@", [NSString stringWithUTF8String:error]);'
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

  # `libskia.a` is static, so its deps must be linked explicitly on Darwin
  # (otherwise we hit undefined `_jpeg_*`/`_WebP*` symbols, e.g. in the thumbnailer).
  env.NIX_LDFLAGS = lib.optionalString clangStdenv.hostPlatform.isDarwin "-ljpeg -lwebp -lwebpdemux -lwebpmux";

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
  ''
  + lib.optionalString clangStdenv.hostPlatform.isDarwin ''
    install -d "$out/Applications"
    if [ -d "$out/bin/aseprite.app" ]; then
      rm -rf "$out/Applications/Aseprite.app"
      mv "$out/bin/aseprite.app" "$out/Applications/Aseprite.app"
    fi
    # Generate the `.icns` files referenced by Info.plist from the shipped PNGs.
    res="$out/Applications/Aseprite.app/Contents/Resources"
    icons="$res/data/icons"
    if [ -d "$icons" ] && command -v png2icns >/dev/null; then
      for spec in "Aseprite ase" "Document doc" "Extension ext"; do
        set -- $spec
        name="$1"
        prefix="$2"
        png2icns "$res/$name.icns" \
          "$icons/''${prefix}16.png" \
          "$icons/''${prefix}32.png" \
          "$icons/''${prefix}128.png" \
          "$icons/''${prefix}256.png"
      done
    fi
    # Keep $out/bin clean on Darwin; the bundle lives under $out/Applications.
    rmdir "$out/bin" 2>/dev/null || true
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
    maintainers = [ lib.maintainers.iamanaws ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "aseprite";
  };
})
