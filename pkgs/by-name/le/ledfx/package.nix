{
  lib,
  fetchPypi,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "ledfx";
  version = "2.0.111";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-b6WHulQa1er0DpMfeJLqqb4z8glUt1dHvvNigXgrf7Y=";
  };

  pythonRelaxDeps = true;

  pythonRemoveDeps = [
    # not packaged
    "rpi-ws281x"
  ];

  build-system = with python3.pkgs; [
    cython
    pdm-backend
  ];

  dependencies = with python3.pkgs; [
    aiohttp
    aiohttp-cors
    aubio
    certifi
    flux-led
    python-dotenv
    icmplib
    mss
    multidict
    netifaces2
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
    vnoise
    voluptuous
    zeroconf
  ];

  # Project has no tests
  doCheck = false;

  meta = {
    description = "Network based LED effect controller with support for advanced real-time audio effects";
    homepage = "https://github.com/LedFx/LedFx";
    changelog = "https://github.com/LedFx/LedFx/blob/${version}/CHANGELOG.rst";
    license = lib.licenses.gpl3Only;
    teams = [ lib.teams.c3d2 ];
    mainProgram = "ledfx";
  };
}
