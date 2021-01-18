{ lib
, mkDerivation
, fetchFromGitHub
, pkg-config
, cmake
, boost
, fftwFloat
, gnuradio
, liquid-dsp
, qtbase
, wrapQtAppsHook
}:

mkDerivation rec {
  pname = "inspectrum";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "miek";
    repo = "inspectrum";
    rev = "v${version}";
    sha256 = "1x6nyn429pk0f7lqzskrgsbq09mq5787xd4piic95add6n1cc355";
  };

  nativeBuildInputs = [ cmake pkg-config wrapQtAppsHook ];
  buildInputs = [
    fftwFloat
    boost
    gnuradio
    liquid-dsp
    qtbase
  ];

  meta = with lib; {
    description = "Tool for analysing captured signals from sdr receivers";
    homepage = "https://github.com/miek/inspectrum";
    maintainers = with maintainers; [ mog ];
    platforms = platforms.linux;
    license = licenses.gpl3Plus;
  };
}
