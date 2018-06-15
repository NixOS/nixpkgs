{ stdenv, fetchFromGitHub, pkgconfig, qmake, qtx11extras, qttools, mpv }:

stdenv.mkDerivation rec {
  name = "mpc-qt-${version}";
  version = "18.03";

  src = fetchFromGitHub {
    owner = "cmdrkotori";
    repo = "mpc-qt";
    rev = "v${version}";
    sha256 = "0mhzdgjgv08cvnscbfndpr0s8ndbcf91b61zfqspa1qv4wlqd716";
  };

  nativeBuildInputs = [ pkgconfig qmake qttools ];

  buildInputs = [ mpv qtx11extras ];

  qmakeFlags = [ "QMAKE_LUPDATE=${qttools.dev}/bin/lupdate" ];

  meta = with stdenv.lib; {
    description = "Media Player Classic Qute Theater";
    homepage = https://github.com/cmdrkotori/mpc-qt;
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ romildo ];
  };
}
