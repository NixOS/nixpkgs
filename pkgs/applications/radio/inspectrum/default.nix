{ lib
, gnuradio3_8Minimal
, thrift
, fetchFromGitHub
, pkg-config
, cmake
, fftwFloat
, qt5
, liquid-dsp
}:

gnuradio3_8Minimal.pkgs.mkDerivation rec {
  pname = "inspectrum";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "miek";
    repo = "inspectrum";
    rev = "v${version}";
    sha256 = "1x6nyn429pk0f7lqzskrgsbq09mq5787xd4piic95add6n1cc355";
  };

  nativeBuildInputs = [
    cmake
    qt5.wrapQtAppsHook
    pkg-config
  ];
  buildInputs = [
    fftwFloat
    liquid-dsp
    qt5.qtbase
  ] ++ lib.optionals (gnuradio3_8Minimal.hasFeature "gr-ctrlport") [
    thrift
    gnuradio3_8Minimal.unwrapped.python.pkgs.thrift
  ];

  meta = with lib; {
    description = "Tool for analysing captured signals from sdr receivers";
    homepage = "https://github.com/miek/inspectrum";
    maintainers = with maintainers; [ mog ];
    platforms = platforms.linux;
    license = licenses.gpl3Plus;
  };
}
