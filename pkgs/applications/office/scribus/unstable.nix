{ boost
, cairo
, cmake
, cups
, fetchpatch
, fetchurl
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
, pkgconfig
, podofo
, poppler
, poppler_data
, python2
, qtbase
, qtimageformats
, qttools
, stdenv
}:

let
  pythonEnv = python2.withPackages (
    ps: [
      ps.pillow
      ps.tkinter
    ]
  );
in
mkDerivation rec {
  pname = "scribus";

  version = "1.5.5";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-devel/${pname}-${version}.tar.xz";
    sha256 = "eQiyGmzoQyafWM7fX495GJMlfmIBzOX73ccNrKL+P3E=";
  };

  patches = [
    # fix build with Poppler 0.82
    (
      fetchpatch {
        url = "https://github.com/scribusproject/scribus/commit/6db15ec1af791377b28981601f8c296006de3c6f.patch";
        sha256 = "1y6g3avmsmiyaj8xry1syaz8sfznsavh6l2rp13pj2bwsxfcf939";
      }
    )
    # fix build with Poppler 0.83
    (
      fetchpatch {
        url = "https://github.com/scribusproject/scribus/commit/b51c2bab4d57d685f96d427d6816bdd4ecfb4674.patch";
        sha256 = "031yy9ylzksczfnpcc4glfccz025sn47zg6fqqzjnqqrc16bgdlx";
      }
    )
    # fix build with Poppler 0.84
    # TODO: Remove patches with scribus version > 1.5.5 as it should be fixed upstream in next version
    (
      fetchpatch {
        url = "https://github.com/scribusproject/scribus/commit/3742559924136c2471ab15081c5b600dd5feaeb0.patch";
        sha256 = "1d72h7jbajy9w83bnxmhn1ca947hpfxnfbmq30g5ljlj824c7y9y";
      }
    )
  ];

  enableParallelBuilding = true;

  nativeBuildInputs = [
    cmake
    pkgconfig
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

  meta = with stdenv.lib; {
    maintainers = with maintainers; [
      erictapen
      kiwi
    ];
    platforms = platforms.linux;
    description = "Desktop Publishing (DTP) and Layout program for Linux";
    homepage = "http://www.scribus.net";
    # There are a lot of licenses... https://github.com/scribusproject/scribus/blob/20508d69ca4fc7030477db8dee79fd1e012b52d2/COPYING#L15-L19
    license = with licenses; [
      bsd3
      gpl2
      mit
      publicDomain
    ];
  };
}
