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
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "miek";
    repo = "inspectrum";
    rev = "v${version}";
    sha256 = "sha256-yY2W2hQpj8TIxiQBSbQHq0J16n74OfIwMDxFt3mLZYc=";
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
    mainProgram = "inspectrum";
    homepage = "https://github.com/miek/inspectrum";
    maintainers = with maintainers; [ mog ];
    platforms = platforms.linux;
    license = licenses.gpl3Plus;
  };
}
