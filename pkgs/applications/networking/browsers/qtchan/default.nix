{ stdenv, fetchFromGitHub, qt5 }:

stdenv.mkDerivation rec {
  name = "qtchan-${version}";
  version = "0.100";

  src = fetchFromGitHub {
    owner  = "siavash119";
    repo   = "qtchan";
    rev    = "v${version}";
    sha256 = "0n94jd6b1y8v6x5lkinr9rzm4bjg9xh9m7zj3j73pgq829gpmj3a";
  };

  enableParallelBuilding = true;
  nativeBuildInputs = [ qt5.qmake ];
  buildInputs = [ qt5.qtbase ];

  installPhase = ''
    mkdir -p $out/bin
    cp qtchan $out/bin
  '';

  meta = with stdenv.lib; {
    description = "4chan browser in qt5";
    homepage    = "https://github.com/siavash119/qtchan";
    license     = licenses.mit;
    maintainers = with maintainers; [ chiiruno ];
    platforms   = platforms.linux;
  };
}
