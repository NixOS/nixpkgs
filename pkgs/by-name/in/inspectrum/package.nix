{
  lib,
  gnuradioMinimal,
  thrift,
  fetchFromGitHub,
  pkg-config,
  cmake,
  fftwFloat,
  qt5,
  liquid-dsp,
}:

gnuradioMinimal.pkgs.mkDerivation rec {
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
  ]
  ++ lib.optionals (gnuradioMinimal.hasFeature "gr-ctrlport") [
    thrift
    gnuradioMinimal.unwrapped.python.pkgs.thrift
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
