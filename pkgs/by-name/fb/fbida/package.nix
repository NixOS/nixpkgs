{
  lib,
  stdenv,
  fetchurl,
  libGL,
  libjpeg,
  libexif,
  giflib,
  libtiff,
  libpng,
  libwebp,
  libdrm,
  pkg-config,
  freetype,
  fontconfig,
  which,
  imagemagick,
  curl,
  sane-backends,
  libxpm,
  libepoxy,
  pixman,
  poppler,
  libgbm,
  lirc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fbida";
  version = "2.14";

  src = fetchurl {
    url = "http://dl.bytesex.org/releases/fbida/fbida-${finalAttrs.version}.tar.gz";
    sha256 = "0f242mix20rgsqz1llibhsz4r2pbvx6k32rmky0zjvnbaqaw1dwm";
  };

  patches = [
    # Upstream patch to fix build on -fno-common toolchains.
    (fetchurl {
      name = "no-common.patch";
      url = "https://git.kraxel.org/cgit/fbida/patch/?id=1bb8a8aa29845378903f3c690e17c0867c820da2";
      sha256 = "0n5vqbp8wd87q60zfwdf22jirggzngypc02ha34gsj1rd6pvwahi";
    })
    # Prevents using function declaration without explicit parameters.
    ./function-parameters.patch
  ];

  nativeBuildInputs = [
    pkg-config
    which
  ];
  buildInputs = [
    libGL
    libexif
    libjpeg
    libpng
    giflib
    freetype
    fontconfig
    libtiff
    libwebp
    imagemagick
    curl
    sane-backends
    libdrm
    libxpm
    libepoxy
    pixman
    poppler
    lirc
    libgbm
  ];

  makeFlags = [
    "prefix=$(out)"
    "verbose=yes"
    "STRIP="
    "JPEG_VER=62"
  ];

  postPatch = ''
    sed -e 's@ cpp\>@ gcc -E -@' -i GNUmakefile
    sed -e 's@$(HAVE_LINUX_FB_H)@yes@' -i GNUmakefile
  '';

  meta = {
    description = "Image viewing and manipulation programs including fbi, fbgs, ida, exiftran and thumbnail.cgi";
    homepage = "https://www.kraxel.org/blog/linux/fbida/";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ pSub ];
    platforms = lib.platforms.linux;
  };
})
