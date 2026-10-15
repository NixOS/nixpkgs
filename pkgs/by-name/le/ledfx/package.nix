{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "ledfx";
  version = "2.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "LedFx";
    repo = "LedFx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tLX1WTXshVe24v53EvME1Nw4ob52dNB1olLoeRK7HJs=";
  };

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
    pyfastnoiselite-ledfx
    netifaces2
    packaging
    samplerate-ledfx
    audio-hotplug
    aiosendspin
    pyflac
    dbus-fast
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
    platforms = lib.platforms.linux;
  };
})
