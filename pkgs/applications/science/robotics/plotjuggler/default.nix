{ lib
, cmake
, extra-cmake-modules
, fetchFromGitHub
, mkDerivation
, mosquitto
, protobuf
, qtbase
, qtsvg
, qtwebsockets
, qtx11extras
, zeromq
, zstd
}:

mkDerivation rec {
  pname = "PlotJuggler";
  version = "3.6.0";

  src = fetchFromGitHub {
    owner = "facontidavide";
    repo = "PlotJuggler";
    rev = version;
    sha256 = "sha256-b/0ttdTF5BFTSP6DGMUg0bziwJQ2SRK3fsTeKoxkzjc=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  buildInputs = [
    mosquitto
    protobuf
    qtbase
    qtsvg
    qtwebsockets
    qtx11extras
    zeromq
    zstd
  ];

  # Remove executable bit from libraries so they don't get wrapped in wrap-qt-apps-hook
  preFixup = ''
    chmod -x $out/bin/*.dylib $out/bin/*.so
  '';

  meta = with lib; {
    homepage = "https://www.plotjuggler.io/";
    description = "Fast, intuitive and extensible time series visualization tool.";
    license = licenses.mpl20;
    maintainers = with maintainers; [ bouk ];
    platforms = platforms.unix;
  };
}

