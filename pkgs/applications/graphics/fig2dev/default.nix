{ lib, stdenv, fetchurl, ghostscript, libpng, makeWrapper
, coreutils, bc, gnugrep, gawk, gnused } :

stdenv.mkDerivation rec {
  pname = "fig2dev";
  version = "3.2.8";

  src = fetchurl {
    url = "mirror://sourceforge/mcj/fig2dev-${version}.tar.xz";
    sha256 = "0zg29yqknfafyzmmln4k7kydfb2dapk3r8ffvlqhj3cm8fp5h4lk";
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
