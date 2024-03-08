{ stdenv, lib, callPackage, fetchFromGitHub, cmake, ninja, pkg-config
, curl, freetype, giflib, libjpeg, libpng, libwebp, pixman, tinyxml, zlib
, harfbuzzFull, glib, fontconfig, pcre
, libX11, libXext, libXcursor, libXxf86vm, libGL, libXi
, cmark
}:

# Unfree version is not redistributable:
# https://dev.aseprite.org/2016/09/01/new-source-code-license/
# Consider supporting the developer: https://aseprite.org/#buy

let
  skia = callPackage ./skia.nix {};
in
stdenv.mkDerivation rec {
  pname = "aseprite";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "aseprite";
    repo = "aseprite";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-8PXqMDf2ATxmtFqyZlGip+DhGrdK8M6Ztte7fGH6Fmo=";
  };

  nativeBuildInputs = [
    cmake pkg-config ninja
  ];

  buildInputs = [
    curl freetype giflib libjpeg libpng libwebp pixman tinyxml zlib
    libX11 libXext libXcursor libXxf86vm
    cmark
    harfbuzzFull glib fontconfig pcre
    skia libGL libXi
  ];

  patches = [
    ./shared-libwebp.patch
    ./shared-skia-deps.patch
  ];

  postPatch = ''
    sed -i src/ver/CMakeLists.txt -e "s-set(VERSION \".*\")-set(VERSION \"$version\")-"
  '';

  cmakeFlags = [
    "-DENABLE_UPDATER=OFF"
    "-DUSE_SHARED_CURL=ON"
    "-DUSE_SHARED_FREETYPE=ON"
    "-DUSE_SHARED_GIFLIB=ON"
    "-DUSE_SHARED_JPEGLIB=ON"
    "-DUSE_SHARED_LIBPNG=ON"
    "-DUSE_SHARED_LIBWEBP=ON"
    "-DUSE_SHARED_PIXMAN=ON"
    "-DUSE_SHARED_TINYXML=ON"
    "-DUSE_SHARED_ZLIB=ON"
    "-DUSE_SHARED_CMARK=ON"
    "-DUSE_SHARED_HARFBUZZ=ON"
    "-DUSE_SHARED_WEBP=ON"
    # Disable libarchive programs.
    "-DENABLE_CAT=OFF"
    "-DENABLE_CPIO=OFF"
    "-DENABLE_TAR=OFF"
    # UI backend.
    "-DLAF_WITH_EXAMPLES=OFF"
    "-DLAF_OS_BACKEND=skia"
    "-DENABLE_DESKTOP_INTEGRATION=ON"
    "-DSKIA_DIR=${skia}"
    "-DSKIA_LIBRARY_DIR=${skia}/out/Release"
  ];

  postInstall = ''
    # Install desktop icons.
    src="$out/share/aseprite/data/icons"
    for size in 16 32 48 64; do
      dst="$out"/share/icons/hicolor/"$size"x"$size"
      install -Dm644 "$src"/ase"$size".png "$dst"/apps/aseprite.png
      install -Dm644 "$src"/doc"$size".png "$dst"/mimetypes/aseprite.png
    done
    # Delete unneeded artifacts of bundled libraries.
    rm -rf "$out"/include "$out"/lib
  '';

  passthru = { inherit skia; };

  meta = with lib; {
    homepage = "https://www.aseprite.org/";
    description = "Animated sprite editor & pixel art tool";
    license = licenses.unfree;
    longDescription =
      ''Aseprite is a program to create animated sprites. Its main features are:

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

        This version is not redistributable: https://dev.aseprite.org/2016/09/01/new-source-code-license/
        Consider supporting the developer: https://aseprite.org/#buy
      '';
    maintainers = with maintainers; [ orivej ];
    platforms = platforms.linux;
  };
}
