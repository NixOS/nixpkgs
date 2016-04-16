{ stdenv, fetchFromGitHub, qt4, qmake4Hook }:

let
  version = "1.08.03";
in
stdenv.mkDerivation {
  name = "qtbitcointrader-${version}";

  src = fetchFromGitHub {
    owner = "JulyIGHOR";
    repo = "QtBitcoinTrader";
    rev = "ee30cf158fa8535f2155a387558d3b8994728c28";
    sha256 = "0kxb0n11agqid0nyqdspfndm03b8l0nl8x4yx2hsrizs6m5z08h4";
  };

  buildInputs = [ qt4 ];

  nativeBuildHooks = [ qmake4Hook ];

  postUnpack = "sourceRoot=\${sourceRoot}/src";

  preConfigure = ''
    qmakeFlags="$qmakeFlags \
      DESKTOPDIR=$out/share/applications \
      ICONDIR=$out/share/pixmaps \
    "
  '';

  meta = with stdenv.lib;
    { description = "Secure bitcoin trading client";
      homepage = https://centrabit.com/;
      license = licenses.lgpl3;
      platforms = qt4.meta.platforms;
      maintainers = [ maintainers.ehmry ];
    };
}
