{ stdenv, fetchurl, fetchpatch, bzip2, freetype, graphviz, ghostscript
, libjpeg, libpng, libtiff, libxml2, zlib, libtool, xz, libX11
, libwebp, quantumdepth ? 8, fixDarwinDylibNames }:

let version = "1.3.25"; in

stdenv.mkDerivation {
  name = "graphicsmagick-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/graphicsmagick/GraphicsMagick-${version}.tar.xz";
    sha256 = "17xcc7pfcmiwpfr1g8ys5a7bdnvqzka53vg3kkzhwwz0s99gljyn";
  };

  patches = [
    ./disable-popen.patch
    (fetchpatch {
      url = "https://sources.debian.net/data/main/g/graphicsmagick/1.3.25-5/debian/patches/CVE-2016-7996_CVE-2016-7997.patch";
      sha256 = "0xsby2z8n7cnnln7szjznq7iaabq323wymvdjra59yb41aix74r2";
    })
    (fetchpatch {
      url = "https://sources.debian.net/data/main/g/graphicsmagick/1.3.25-5/debian/patches/CVE-2016-7800_part1.patch";
      sha256 = "02s0x9bkbnm5wrd0d2x9ld4d9z5xqpfk310lyylyr5zlnhqxmwgn";
    })
    (fetchpatch {
      url = "https://sources.debian.net/data/main/g/graphicsmagick/1.3.25-5/debian/patches/CVE-2016-7800_part2.patch";
      sha256 = "1h4xv3i1aq5avsd584rwa5sa7ca8f7w9ggmh7j2llqq5kymwsv5f";
    })
    (fetchpatch {
      url = "https://sources.debian.net/data/main/g/graphicsmagick/1.3.25-5/debian/patches/CVE-2016-8682.patch";
      sha256 = "1wfirw2yi5y72657kvnbgjs0f9b3rs9nvk8gjbwhb9a03z9ws0y5";
    })
    (fetchpatch {
      url = "https://sources.debian.net/data/main/g/graphicsmagick/1.3.25-5/debian/patches/CVE-2016-8683.patch";
      sha256 = "102252zb34nj6alk1nhh1wbn3apd2v9rzk7clmm237332yj72vif";
    })
    (fetchpatch {
      url = "https://sources.debian.net/data/main/g/graphicsmagick/1.3.25-5/debian/patches/CVE-2016-8684.patch";
      sha256 = "1p36gpz904wnmbz1n64x4pdpg8lp9zs3gx0awklxqdvgl8m82vvy";
    })
    (fetchpatch {
      url = "https://sources.debian.net/data/main/g/graphicsmagick/1.3.25-7/debian/patches/CVE-2016-9830.patch";
      sha256 = "0qh15sd7nx7vf9sld4453iml951bwsx2fx84hxc7plhds2k3gjpa";
    })
  ];

  configureFlags = [
    "--enable-shared"
    "--with-quantum-depth=${toString quantumdepth}"
    "--with-gslib=yes"
  ];

  buildInputs =
    [ bzip2 freetype ghostscript graphviz libjpeg libpng libtiff libX11 libxml2
      zlib libtool libwebp
    ]
    ++ stdenv.lib.optional stdenv.isDarwin fixDarwinDylibNames;

  nativeBuildInputs = [ xz ];

  postInstall = ''
    sed -i 's/-ltiff.*'\'/\'/ $out/bin/*
  '';

  meta = {
    homepage = http://www.graphicsmagick.org;
    description = "Swiss army knife of image processing";
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.all;
  };
}
