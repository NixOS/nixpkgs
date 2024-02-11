{ lib
, fetchPypi
, python3
}:

python3.pkgs.buildPythonPackage rec {
  pname = "ledfx";
  version = "2.0.92";
  pyproject= true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-tt2D8pjU/SClweAn9vHYl+H1POdB1u2SQfrnZZvBQ7I=";
  };

  pythonRelaxDeps = true;

  pythonRemoveDeps = [
    # not packaged
    "rpi-ws281x"
  ];

  nativeBuildInputs = with python3.pkgs; [
    cython
    poetry-core
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = with python3.pkgs; [
    aiohttp
    aiohttp-cors
    aubio
    certifi
    flux-led
    python-dotenv
    icmplib
    mss
    multidict
    numpy
    openrgb-python
    paho-mqtt
    pillow
    psutil
    pybase64
    pyserial
    pystray
    python-mbedtls
    python-osc
    python-rtmidi
    # rpi-ws281x # not packaged
    requests
    sacn
    samplerate
    sentry-sdk
    setuptools
    sounddevice
    stupidartnet
    uvloop
    voluptuous
    zeroconf
  ];

  # Project has no tests
  doCheck = false;

  meta = with lib; {
    description = "Network based LED effect controller with support for advanced real-time audio effects";
    homepage = "https://github.com/LedFx/LedFx";
    changelog = "https://github.com/LedFx/LedFx/blob/${version}/CHANGELOG.rst";
    license = licenses.gpl3Only;
    maintainers = teams.c3d2.members;
  };
}
