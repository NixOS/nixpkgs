{ lib
, stdenv
, fetchurl
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
