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
  version = "3.2.9";

  src = fetchurl {
    url = "mirror://sourceforge/mcj/fig2dev-${version}.tar.xz";
    hash = "sha256-FeJGyNE8xy3iXggxQDitUM59Le+pzxr8Fy/X9ZMgkLE=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ libpng ];

  GSEXE="${ghostscript}/bin/gs";

  configureFlags = [ "--enable-transfig" ];

  postInstall = ''
    wrapProgram $out/bin/fig2ps2tex \
        --set PATH ${lib.makeBinPath [ coreutils bc gnugrep gawk ]}
    wrapProgram $out/bin/pic2tpic \
        --set PATH ${lib.makeBinPath [ gnused ]}
  '';

  meta = with lib; {
    description = "Tool to convert Xfig files to other formats";
    homepage = "https://mcj.sourceforge.net/";
    license = licenses.xfig;
    platforms = platforms.unix;
    maintainers = with maintainers; [ lesuisse ];
  };
}
