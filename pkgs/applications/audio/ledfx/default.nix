{ lib
<<<<<<< HEAD
, fetchPypi
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, python3
}:

python3.pkgs.buildPythonPackage rec {
  pname = "ledfx";
<<<<<<< HEAD
  version = "2.0.69";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gkO6XYiPMkU/zRLvc0yd3jJXVcAgAkR1W1ELTSN461o=";
=======
  version = "2.0.67";
  format = "setuptools";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    hash = "sha256-lFxAMjglQZXCySr83PtvStU6hw2ucQu+rSjIHo1yZBk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPatch = ''
    substituteInPlace setup.py \
<<<<<<< HEAD
=======
      --replace '"openrgb-python~=0.2.10",' "" \
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    openrgb-python
=======
    # openrgb-python # not packaged
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    description = "Network based LED effect controller with support for advanced real-time audio effects";
=======
    description = "LedFx is a network based LED effect controller with support for advanced real-time audio effects";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    homepage = "https://github.com/LedFx/LedFx";
    changelog = "https://github.com/LedFx/LedFx/blob/${version}/CHANGELOG.rst";
    license = licenses.gpl3Only;
    maintainers = teams.c3d2.members;
  };
}
