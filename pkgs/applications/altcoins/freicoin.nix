{ fetchFromGitHub, stdenv, db, boost, gmp, mpfr, miniupnpc, qt4, qmake4Hook, unzip }:

stdenv.mkDerivation rec {
  version = "0.8.6-2";
  name = "freicoin-${version}";

  src = fetchFromGitHub {
    owner = "freicoin";
    repo = "freicoin";
    rev = "v${version}";
    sha256 = "1m5pcnfhwhcj7q00p2sy3h73rkdm3w6grmljgiq53gshcj08cq1z";
  };

  qmakeFlags = ["USE_UPNP=-"];

  # I think that openssl and zlib are required, but come through other
  # packages

  preBuild = "unset AR";

  installPhase = ''
    mkdir -p $out/bin
    cp freicoin-qt $out/bin
  '';

  nativeBuildInputs = [ qmake4Hook ];
  buildInputs = [ db boost gmp mpfr qt4 ];

  meta = with stdenv.lib; {
    description = "Peer-to-peer currency with demurrage fee";
    homepage = http://freicoi.in/;
    license = licenses.mit;
    maintainers = [ maintainers.viric ];
    platforms = platforms.linux;
  };
}
