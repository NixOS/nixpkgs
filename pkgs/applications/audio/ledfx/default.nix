{ lib
, fetchPypi
, python3
}:

python3.pkgs.buildPythonPackage rec {
  pname = "ledfx";
  version = "2.0.86";
  pyproject= true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-miOGMsrvK3A3SYnd+i/lqB+9GOHtO4F3RW8NkxDgFqU=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'rpi-ws281x>=4.3.0; platform_system == \"Linux\"'," "" \
      --replace "sentry-sdk==1.38.0" "sentry-sdk" \
      --replace "~=" ">="
  '';

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
  ];

  propagatedBuildInputs = with python3.pkgs; [
    aiohttp
    aiohttp-cors
    aubio
    certifi
    cython
    flux-led
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
    sounddevice
    uvloop
    voluptuous
    zeroconf
  ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "Network based LED effect controller with support for advanced real-time audio effects";
    homepage = "https://github.com/LedFx/LedFx";
    changelog = "https://github.com/LedFx/LedFx/blob/${version}/CHANGELOG.rst";
    license = licenses.gpl3Only;
    maintainers = teams.c3d2.members;
  };
}
