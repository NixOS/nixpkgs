{ lib
, python3
, fetchPypi
}:

python3.pkgs.buildPythonPackage rec {
  pname = "ledfx";
  version = "2.0.67";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-lFxAMjglQZXCySr83PtvStU6hw2ucQu+rSjIHo1yZBk=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'rpi-ws281x>=4.3.0; platform_system == \"Linux\"'," "" \
      --replace '"sentry-sdk==1.14.0",' "" \
      --replace "~=" ">="
  '';

  propagatedBuildInputs = with python3.pkgs; [
    aiohttp
    aiohttp-cors
    aubio
    certifi
    cython
    flux-led
    icmplib
    multidict
    numpy
    openrgb-python
    paho-mqtt
    pillow
    psutil
    pyserial
    pystray
    python-rtmidi
    # rpi-ws281x # not packaged
    requests
    sacn
    samplerate
    sentry-sdk
    sounddevice
    uvloop
    voluptuous
    zeroconf
  ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "LedFx is a network based LED effect controller with support for advanced real-time audio effects";
    homepage = "https://github.com/LedFx/LedFx";
    changelog = "https://github.com/LedFx/LedFx/blob/${version}/CHANGELOG.rst";
    license = licenses.gpl3Only;
    maintainers = teams.c3d2.members;
  };
}
