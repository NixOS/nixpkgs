{ stdenv, fetchurl, pkgconfig, freetype, lcms, libtiff, libxml2
, libart_lgpl, qt4, python2, cups, fontconfig, libjpeg
, zlib, libpng, xorg, cairo, podofo, hunspell, boost, cmake, imagemagick, ghostscript }:

let
  icon = fetchurl {
    url = "https://gist.githubusercontent.com/ejpcmac/a74b762026c9bc4000be624c3d085517/raw/18edc497c5cb6fdeef1c8aede37a0ee68413f9d3/scribus-icon-centered.svg";
    sha256 = "0hq3i7c2l50445an9glhhg47kj26y16svfajc6naqn307ph9vzc3";
  };

  pythonEnv = python2.withPackages(ps: [ps.tkinter ps.pillow]);
in stdenv.mkDerivation rec {
  pname = "scribus";
  version = "1.4.8";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}/${pname}-${version}.tar.xz";
    sha256 = "0bq433myw6h1siqlsakxv6ghb002rp3mfz5k12bg68s0k6skn992";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ pkgconfig cmake ];
  buildInputs = with xorg;
    [ freetype lcms libtiff libxml2 libart_lgpl qt4
      pythonEnv cups fontconfig
      libjpeg zlib libpng podofo hunspell cairo
      boost # for internal 2geom library
      libXaw libXext libX11 libXtst libXi libXinerama
      libpthreadstubs libXau libXdmcp
      imagemagick # To build the icon
    ];

  postPatch = ''
    substituteInPlace scribus/util_ghostscript.cpp \
      --replace 'QString gsName("gs");' \
                'QString gsName("${ghostscript}/bin/gs");'
  '';

  postInstall = ''
    for i in 16 24 48 64 96 128 256 512; do
      mkdir -p $out/share/icons/hicolor/''${i}x''${i}/apps
      convert -background none -resize ''${i}x''${i} ${icon} $out/share/icons/hicolor/''${i}x''${i}/apps/scribus.png
    done
  '';

  meta = {
    maintainers = [ stdenv.lib.maintainers.marcweber ];
    platforms = stdenv.lib.platforms.linux;
    description = "Desktop Publishing (DTP) and Layout program for Linux";
    homepage = https://www.scribus.net;
    license = stdenv.lib.licenses.gpl2;
  };
}
