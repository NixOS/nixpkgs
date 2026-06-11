{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "hifiscan";
  version = "1.5.2";
  pyproject = true;

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    eventkit
    numpy
    sounddevice
    pyqt6
    pyqt6-sip
    pyqtgraph
  ];

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-8eystqjNdDP2X9beogRcsa+Wqu50uMHZv59jdc5GjUc=";
  };

  meta = {
    homepage = "https://github.com/erdewit/HiFiScan";
    description = "Optimize the audio quality of your loudspeakers";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ cab404 ];
    mainProgram = "hifiscan";
  };
})
