{ boost
, cairo
, cmake
, cups
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

  version = "1.5.7";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-devel/${pname}-${version}.tar.xz";
    sha256 = "sha256-MYMWss/Hp2GR0+DT+MImUUfa6gVwFiAo4kPCktgm+M4=";
  };

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
