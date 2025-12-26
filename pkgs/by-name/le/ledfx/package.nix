{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "ledfx";
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "LedFx";
    repo = "LedFx";
    tag = "v${version}";
    hash = "sha256-N9EHK0GVohFCjEKsm3g4h+4XWfzZO1tzdd2z5IN1YjI=";
  };

  postPatch = ''
    substituteInPlace tests/conftest.py \
      --replace-fail '"uv",' "" \
      --replace-fail '"run",' "" \
      --replace-fail '"ledfx",' "\"$out/bin/ledfx\","
  '';

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
    # sorted like in pyproject.toml in upstream
    numpy
    cffi
    aiohttp
    aiohttp-cors
    aubio
    certifi
    multidict
    openrgb-python
    paho-mqtt
    psutil
    pyserial
    pystray
    python-rtmidi
    requests
    sacn
    sentry-sdk
    sounddevice
    samplerate
    icmplib
    voluptuous
    zeroconf
    pillow
    flux-led
    python-osc
    pybase64
    mss
    uvloop
    stupidartnet
    python-dotenv
    vnoise
    netifaces2
    packaging
  ];

  optional-dependencies = {
    hue = with pyproject.pkgs; [ python-mbedtls ];
  };

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
    pytest-asyncio
  ];

  meta = {
    description = "Network based LED effect controller with support for advanced real-time audio effects";
    homepage = "https://github.com/LedFx/LedFx";
    changelog = "https://github.com/LedFx/LedFx/blob/${version}/CHANGELOG.rst";
    license = lib.licenses.gpl3Only;
    teams = [ lib.teams.c3d2 ];
    mainProgram = "ledfx";
  };
}
