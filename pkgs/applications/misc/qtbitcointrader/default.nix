{ stdenv, fetchFromGitHub, qt }:

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

  buildInputs = [ qt ];

  postUnpack = "sourceRoot=\${sourceRoot}/src";

  configurePhase = ''
    qmake \
      PREFIX=$out \
      DESKTOPDIR=$out/share/applications \
      ICONDIR=$out/share/pixmaps \
        QtBitcoinTrader_Desktop.pro
  '';

  meta = with stdenv.lib;
    { description = "Secure bitcoin trading client";
      homepage = https://centrabit.com/;
      license = licenses.lgpl3;
      platforms = qt.meta.platforms;
      maintainers = [ maintainers.ehmry ];
    };
}
