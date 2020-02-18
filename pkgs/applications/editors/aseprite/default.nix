{ stdenv, lib, callPackage, fetchFromGitHub, fetchpatch, cmake, ninja, pkgconfig
, curl, freetype, giflib, libjpeg, libpng, libwebp, pixman, tinyxml, zlib
, harfbuzzFull, glib, fontconfig, pcre
, libX11, libXext, libXcursor, libXxf86vm, libGL
, unfree ? false
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
  version = if unfree then "1.2.16.3" else "1.1.7";

  src = fetchFromGitHub {
    owner = "aseprite";
    repo = "aseprite";
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = if unfree
      then "16yn7y9xdc5jd50cq7bmsm320gv23pp71lr8hg2nmynzc8ibyda8"
      else "0gd49lns2bpzbkwax5jf9x1xmg1j8ij997kcxr2596cwiswnw4di";
  };

  nativeBuildInputs = [
    cmake pkgconfig
  ] ++ lib.optionals unfree [ ninja ];

  buildInputs = [
    curl freetype giflib libjpeg libpng libwebp pixman tinyxml zlib
    libX11 libXext libXcursor libXxf86vm
  ] ++ lib.optionals unfree [
    cmark
    harfbuzzFull glib fontconfig pcre
    skia libGL
  ];

  patches = if !unfree then [
    ./allegro-glibc-2.30.patch
  ] else [
    (fetchpatch {
      url = "https://github.com/lfont/aseprite/commit/f1ebc47012d3fed52306ed5922787b4b98cc0a7b.patch";
      sha256 = "03xg7x6b9iv7z18vzlqxhcfphmx4v3qhs9f5rgf38ppyklca5jyw";
    })
    (fetchpatch {
      url = "https://github.com/orivej/aseprite/commit/ea87e65b357ad0bd65467af5529183b5a48a8c17.patch";
      sha256 = "1vwn8ivap1pzdh444sdvvkndp55iz146nhmd80xbm8cyzn3qmg91";
    })
  ];

  postPatch = ''
    sed -i src/config.h -e "s-\\(#define VERSION\\) .*-\\1 \"$version\"-"
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
    "-DWITH_DESKTOP_INTEGRATION=ON"
    "-DWITH_WEBP_SUPPORT=ON"
  ] ++ lib.optionals unfree [
    "-DUSE_SHARED_CMARK=ON"
    "-DUSE_SHARED_HARFBUZZ=ON"
    # Aseprite needs internal freetype headers.
    "-DUSE_SHARED_FREETYPE=OFF"
    # Disable libarchive programs.
    "-DENABLE_CAT=OFF"
    "-DENABLE_CPIO=OFF"
    "-DENABLE_TAR=OFF"
    # UI backend.
    "-DLAF_OS_BACKEND=skia"
    "-DSKIA_DIR=${skia}"
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

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = https://www.aseprite.org/;
    description = "Animated sprite editor & pixel art tool";
    license = if unfree then licenses.unfree else licenses.gpl2;
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
      '' + lib.optionalString unfree
      ''
        This version is not redistributable: https://dev.aseprite.org/2016/09/01/new-source-code-license/
        Consider supporting the developer: https://aseprite.org/#buy
      '';
    maintainers = with maintainers; [ orivej ];
    platforms = platforms.linux;
  };
}
