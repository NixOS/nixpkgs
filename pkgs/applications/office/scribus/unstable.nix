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

  version = "1.5.7";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-devel/${pname}-${version}.tar.xz";
    sha256 = "sha256-MYMWss/Hp2GR0+DT+MImUUfa6gVwFiAo4kPCktgm+M4=";
  };

  patches = [
    # For harfbuzz >= 2.9.0
    (fetchpatch {
      url = "https://github.com/scribusproject/scribus/commit/1b546978bc4ea0b2a73fbe4d7cf947887e865162.patch";
      sha256 = "sha256-noRCaN63ZYFfXmAluEYXdFPNOk3s5W3KBAsLU1Syxv4=";
    })
    # For harfbuzz >= 3.0
    (fetchpatch {
      url = "https://github.com/scribusproject/scribus/commit/68ec41169eaceea4a6e1d6f359762a191c7e61d5.patch";
      sha256 = "sha256-xhp65qVvaof0md1jb3XHZw7uFX1RtNxPfUOaVnvZV1Y=";
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
