{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  bzip2,
  zlib,
  newt,
  openssl,
  pkg-config,
  slang,
  libxcrypt,
  autoreconfHook,
}:
stdenv.mkDerivation rec {
  pname = "partimage";
  version = "0.6.9";

  enableParallelBuilding = true;

  src = fetchurl {
    url = "mirror://sourceforge/partimage/partimage-${version}.tar.bz2";
    sha256 = "0db6xiphk6xnlpbxraiy31c5xzj0ql6k4rfkmqzh665yyj0nqfkm";
  };

  configureFlags = [ "--with-ssl-headers=${openssl.dev}/include/openssl" ];

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];
  buildInputs = [
    bzip2
    zlib
    newt
    newt
    openssl
    slang
    libxcrypt
  ];

  patches = [
    ./gentoos-zlib.patch
    (fetchpatch {
      name = "openssl-1.1.patch";
      url =
        "https://gitweb.gentoo.org/repo/gentoo.git/plain/sys-block/partimage/files/"
        + "partimage-0.6.9-openssl-1.1-compatibility.patch?id=3fe8e9910002b6523d995512a646b063565d0447";
      sha256 = "1hs0krxrncxq1w36bhad02yk8yx71zcfs35cw87c82sl2sfwasjg";
    })
    (fetchpatch {
      url = "https://sources.debian.org/data/main/p/partimage/0.6.9-8/debian/patches/04-fix-FTBFS-glic-2.28.patch";
      sha256 = "0xid5636g58sxbhxnjmfjdy7y8rf3c77zmmpfbbqv4lv9jd2gmxm";
    })
  ];

  meta = {
    description = "Opensource disk backup software";
    homepage = "https://www.partimage.org";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.marcweber ];
    platforms = lib.platforms.linux;
  };
}
