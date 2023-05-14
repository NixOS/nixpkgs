{ boost
, cairo
, cmake
, cups
, fetchurl
, fetchpatch
, fontconfig
, freetype
, harfbuzzFull
, hunspell
, lcms2
, libjpeg
, libtiff
, libxml2
, mkDerivation
, pixman
, pkg-config
, podofo
, poppler
, poppler_data
, python3
, qtbase
, qtimageformats
, qttools
, lib
}:

let
  pythonEnv = python3.withPackages (
    ps: [
      ps.pillow
      ps.tkinter
    ]
  );
in
mkDerivation rec {
  pname = "scribus";

  version = "1.5.8";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-devel/${pname}-${version}.tar.xz";
    hash = "sha256-R4Fuj89tBXiP8WqkSZ+X/yJDHHd6d4kUmwqItFHha3Q=";
  };

  patches = [
    # For Poppler 22.02
    (fetchpatch {
      url = "https://github.com/scribusproject/scribus/commit/85c0dff3422fa3c26fbc2e8d8561f597ec24bd92.patch";
      sha256 = "YR0ii09EVU8Qazz6b8KAIWsUMTwPIwO8JuQPymAWKdw=";
    })
    (fetchpatch {
      url = "https://github.com/scribusproject/scribus/commit/f75c1613db67f4067643d0218a2db3235e42ec9f.patch";
      sha256 = "vJU8HsKHE3oXlhcXQk9uCYINPYVPF5IGmrWYFQ6Py5c=";
    })
    # For Poppler 22.03
    (fetchpatch {
      url = "https://github.com/scribusproject/scribus/commit/f19410ac3b27e33dd62105746784e61e85b90a1d.patch";
      sha256 = "JHdgntYcioYatPeqpmym3c9dORahj0CinGOzbGtA4ds=";
    })
    # For Poppler 22.04
    (fetchpatch {
      url = "https://github.com/scribusproject/scribus/commit/f2237b8f0b5cf7690e864a22ef7a63a6d769fa36.patch";
      sha256 = "FXpLoX/a2Jy3GcfzrUUyVUfEAp5wAy2UfzfVA5lhwJw=";
    })
    # For Poppler 22.09
    (fetchpatch {
      url = "https://github.com/archlinux/svntogit-community/raw/ea402a588c65d11973b148cf203b3463213431cf/trunk/scribus-1.5.8-poppler-22.09.0.patch";
      sha256 = "IRQ6rSzH6ZWln6F13Ayk8k7ADj8l3lIJlGm/zjEURQM=";
    })
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    boost
    cairo
    cups
    fontconfig
    freetype
    harfbuzzFull
    hunspell
    lcms2
    libjpeg
    libtiff
    libxml2
    pixman
    podofo
    poppler
    poppler_data
    pythonEnv
    qtbase
    qtimageformats
    qttools
  ];

  cmakeFlags = [
    # poppler uses std::optional
    "-DWANT_CPP17=ON"
  ];

  meta = with lib; {
    maintainers = with maintainers; [
      erictapen
      kiwi
    ];
    platforms = platforms.linux;
    description = "Desktop Publishing (DTP) and Layout program for Linux";
    homepage = "https://www.scribus.net";
    # There are a lot of licenses...
    # https://github.com/scribusproject/scribus/blob/20508d69ca4fc7030477db8dee79fd1e012b52d2/COPYING#L15-L19
    license = with licenses; [
      bsd3
      gpl2Plus
      mit
      publicDomain
    ];
  };
}
