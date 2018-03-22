{ stdenv, fetchFromGitHub, pkgconfig, qmake, qtx11extras, qttools, mpv }:

stdenv.mkDerivation rec {
  name = "mpc-qt-${version}";
  version = "17.11";

  src = fetchFromGitHub {
    owner = "cmdrkotori";
    repo = "mpc-qt";
    rev = "v${version}";
    sha256 = "1vi4zsmbzxj6ms8wls9zv15vrskdrhgnj6l41m1fk4scs4jzvbkm";
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
