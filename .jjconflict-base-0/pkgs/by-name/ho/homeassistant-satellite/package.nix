{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "homeassistant-satellite";
  version = "2.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "synesthesiam";
    repo = "homeassistant-satellite";
    rev = "v${version}";
    hash = "sha256-iosutOpkpt0JJIMyALuQSDLj4jk57ITShVyPYlQgMFg=";
  };

  nativeBuildInputs = with python3.pkgs; [
    setuptools
  ];

  pythonRelaxDeps = [
    "aiohttp"
  ];

  propagatedBuildInputs = with python3.pkgs; [
    aiohttp
  ];

  optional-dependencies = {
    pulseaudio = with python3.pkgs; [
      pasimple
      pulsectl
    ];
    silerovad = with python3.pkgs; [
      numpy
      onnxruntime
    ];
    webrtc = with python3.pkgs; [
      webrtc-noise-gain
    ];
  };

  pythonImportsCheck = [
    "homeassistant_satellite"
  ];

  # no tests
  doCheck = false;

  meta = with lib; {
    changelog = "https://github.com/synesthesiam/homeassistant-satellite/blob/v${version}/CHANGELOG.md";
    description = "Streaming audio satellite for Home Assistant";
    homepage = "https://github.com/synesthesiam/homeassistant-satellite";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
    mainProgram = "homeassistant-satellite";
  };
}
