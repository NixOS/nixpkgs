{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "ledfx";
  version = "2.1.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "LedFx";
    repo = "LedFx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-le3SEGI9uis7wx9+SFpn0BJbpCybSecXEcxxAkC910U=";
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
    "xled"
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
    aubio-ledfx
    cython
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
    icmplib
    voluptuous
    zeroconf
    pillow
    flux-led
    lifx-async
    python-osc
    pybase64
    mss
    uvloop
    stupidartnet
    python-dotenv
    pyfastnoiselite
    netifaces2
    packaging
    samplerate-ledfx
    audio-hotplug
    aiosendspin
    pyflac
  ];

  optional-dependencies = {
    hue = with python3.pkgs; [ python-mbedtls ];
  };

  nativeCheckInputs = with python3.pkgs; [
    lifx-emulator-core
    pytest-asyncio
    pytest-order
    pytest-timeout
    pytestCheckHook
  ];

  disabledTests = [
    # requires internet
    "TestURLDownloadWithExternalURL"
  ];

  meta = {
    description = "Network based LED effect controller with support for advanced real-time audio effects";
    homepage = "https://github.com/LedFx/LedFx";
    changelog = "https://github.com/LedFx/LedFx/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
    mainProgram = "ledfx";
  };
})
