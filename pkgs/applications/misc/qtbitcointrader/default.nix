{ stdenv, fetchFromGitHub, qt }:

let
  version = "1.08.02";
in
stdenv.mkDerivation {
  name = "qtbitcointrader-${version}";

  src = fetchFromGitHub {
    owner = "JulyIGHOR";
    repo = "QtBitcoinTrader";
    rev = "452db3ee9447b8f9e7d63253f834b31394b23d92";
    sha256 = "1l2a021dy2j4sr4nmq7wn27r2zli9nigwbviqzain3nlyzq9fjpg";
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
      platforms = platforms.linux;  # arbitrary choice
      maintainers = [ maintainers.emery ];
    };
}
