{ stdenv, lib, fetchFromGitHub, fetchpatch, cmake, pkgconfig
, curl, freetype, giflib, harfbuzz, libjpeg, libpng, libwebp, pixman, tinyxml, zlib
, libX11, libXext, libXcursor, libXxf86vm
, unfree ? false
, cmark
}:

# Unfree version is not redistributable:
# https://dev.aseprite.org/2016/09/01/new-source-code-license/
# Consider supporting the developer: https://aseprite.org/#buy

stdenv.mkDerivation rec {
  name = "aseprite-${version}";
  version = if unfree then "1.2.9" else "1.1.7";

  src = fetchFromGitHub {
    owner = "aseprite";
    repo = "aseprite";
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = if unfree
      then "0a9xk163j0984n8nn6pqf27n83gr6w7g25wkiv591zx88pa6cpbd"
      else "0gd49lns2bpzbkwax5jf9x1xmg1j8ij997kcxr2596cwiswnw4di";
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [
    curl freetype giflib harfbuzz libjpeg libpng libwebp pixman tinyxml zlib
    libX11 libXext libXcursor libXxf86vm
  ] ++ lib.optionals unfree [ cmark harfbuzz ];

  patches = lib.optionals unfree [
    (fetchpatch {
      url = "https://github.com/aseprite/aseprite/commit/cfb4dac6feef1f39e161c23c886055a8f9acfd0d.patch";
      sha256 = "1qhjfpngg8b1vvb9w26lhjjfamfx57ih0p31km3r5l96nm85l7f9";
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
    maintainers = with maintainers; [ orivej ];
    platforms = platforms.linux;
  };
}
