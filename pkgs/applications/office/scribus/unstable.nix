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

  version = "1.5.6.1";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-devel/${pname}-${version}.tar.xz";
    sha256 = "sha256-1CV2lVOc+kDerYq9rwTFHjTU10vK1aLJNNCObp1Dt6s=";
  };

  patches = [
    (fetchpatch {  # fix build with podofo 0.9.7
      url = "https://github.com/scribusproject/scribus/commit/c6182ef92820b422d61c904e40e9fed865458eb5.patch";
      sha256 = "0vp275xfbd4xnj5s55cgzsihgihby5mmjlbmrc7sa6jbrsm8aa2c";
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

  meta = with lib; {
    maintainers = with maintainers; [
      erictapen
      kiwi
    ];
    platforms = platforms.linux;
    description = "Desktop Publishing (DTP) and Layout program for Linux";
    homepage = "https://www.scribus.net";
    # There are a lot of licenses... https://github.com/scribusproject/scribus/blob/20508d69ca4fc7030477db8dee79fd1e012b52d2/COPYING#L15-L19
    license = with licenses; [
      bsd3
      gpl2
      mit
      publicDomain
    ];
  };
}
