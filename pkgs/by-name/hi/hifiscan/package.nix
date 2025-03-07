{
  lib,
  python3Packages,
  fetchPypi,
}:
let
  pname = "hifiscan";
  version = "1.5.2";
  hash = "sha256-8eystqjNdDP2X9beogRcsa+Wqu50uMHZv59jdc5GjUc=";
in
python3Packages.buildPythonApplication {
  inherit pname version;

  pythonPath = with python3Packages; [
    eventkit
    numpy
    sounddevice
    pyqt6
    pyqt6-sip
    pyqtgraph
  ];

  dontUseSetuptoolsCheck = true;

  src = fetchPypi {
    inherit pname version hash;
  };

  meta = with lib; {
    homepage = "https://github.com/erdewit/HiFiScan";
    description = "Optimize the audio quality of your loudspeakers";
    license = licenses.bsd2;
    maintainers = with maintainers; [ cab404 ];
    mainProgram = "hifiscan";
  };
}
