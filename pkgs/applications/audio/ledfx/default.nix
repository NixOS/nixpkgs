{ lib
, fetchpatch
, python3
}:

python3.pkgs.buildPythonPackage rec {
  pname = "ledfx";
  version = "2.0.64";
  format = "setuptools";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    hash = "sha256-TKRa4PcMd0Jl94XD2WubOhmsxZaUplZeWKsuKz83Rl4=";
  };

  patches = [
    # replace tcp-latency which is not packaged with icmplib
    (fetchpatch {
      url = "https://github.com/LedFx/LedFx/commit/98cd4256846ae3bdae7094eeacb3b02a4807dc6f.patch";
      excludes = [
        # only used in win.spec file which is windows specific
        "hiddenimports.py"
      ];
      hash = "sha256-p9fiLdjZI5fe5Qy2xbJIAtblp/7BwUxAvwjHQy5l9nQ=";
    })
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace '"openrgb-python~=0.2.10",' "" \
      --replace '"pyupdater>=3.1.0",' "" \
      --replace "'rpi-ws281x>=4.3.0; platform_system == \"Linux\"'," "" \
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
    # openrgb-python # not packaged
    paho-mqtt
    pillow
    psutil
    pyserial
    pystray
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
