{ lib
, stdenv
, fetchurl
, fetchpatch
, ghostscript
, libpng
, makeWrapper
, coreutils
, bc
, gnugrep
, gawk
, gnused
}:

stdenv.mkDerivation rec {
  pname = "fig2dev";
  version = "3.2.8a";

  src = fetchurl {
    url = "mirror://sourceforge/mcj/fig2dev-${version}.tar.xz";
    sha256 = "1bm75lf9j54qpbjx8hzp6ixaayp1x9w4v3yxl6vxyw8g5m4sqdk3";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2021-3561.patch";
      # Using Debian patch since it is not possible to download it directly from Sourceforge
      url = "https://sources.debian.org/data/main/f/fig2dev/1:3.2.8-3/debian/patches/33_sanitize-color.patch";
      sha256 = "1bppr3li03nj4qjibnddr2f38mpk55pcn5z6k98pf00gabq33fgs";
    })
  ];

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ libpng ];

  GSEXE="${ghostscript}/bin/gs";

  postInstall = ''
    wrapProgram $out/bin/fig2ps2tex \
        --set PATH ${lib.makeBinPath [ coreutils bc gnugrep gawk ]}
    wrapProgram $out/bin/pic2tpic \
        --set PATH ${lib.makeBinPath [ gnused ]}
  '';

  meta = with lib; {
    description = "Tool to convert Xfig files to other formats";
    homepage = "http://mcj.sourceforge.net/";
    license = licenses.xfig;
    platforms = platforms.linux;
    maintainers = with maintainers; [ lesuisse ];
  };
}
