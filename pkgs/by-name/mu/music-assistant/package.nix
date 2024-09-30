{ lib
, python3
, fetchFromGitHub
, ffmpeg-headless
, nixosTests
, substituteAll
, providers ? [ ]
}:

let
  python = python3.override {
    self = python;
    packageOverrides = self: super: {
      music-assistant-frontend = self.callPackage ./frontend.nix { };
    };
  };

  providerPackages = (import ./providers.nix).providers;
  providerNames = lib.attrNames providerPackages;
  providerDependencies = lib.concatMap (provider: (providerPackages.${provider} python.pkgs)) providers;

  pythonPath = python.pkgs.makePythonPath providerDependencies;
in

python.pkgs.buildPythonApplication rec {
  pname = "music-assistant";
  version = "2.2.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "music-assistant";
    repo = "server";
    rev = "refs/tags/${version}";
    hash = "sha256-BEbcIq+qtJ1OffT2we6qajzvDYDu09rMcmJF1F06xZQ=";
  };

  patches = [
    (substituteAll {
      src = ./ffmpeg.patch;
      ffmpeg = "${lib.getBin ffmpeg-headless}/bin/ffmpeg";
      ffprobe = "${lib.getBin ffmpeg-headless}/bin/ffprobe";
    })
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "0.0.0" "${version}"
  '';

  build-system = with python.pkgs; [
    setuptools
  ];

  dependencies = with python.pkgs; [
    aiohttp
    mashumaro
    orjson
  ] ++ optional-dependencies.server;

  optional-dependencies = with python.pkgs; {
    server = [
      aiodns
      aiofiles
      aiohttp
      aiorun
      aiosqlite
      asyncio-throttle
      brotli
      certifi
      colorlog
      cryptography
      eyed3
      faust-cchardet
      ifaddr
      mashumaro
      memory-tempfile
      music-assistant-frontend
      orjson
      pillow
      python-slugify
      shortuuid
      unidecode
      xmltodict
      zeroconf
    ];
  };

  nativeCheckInputs = with python.pkgs; [
    aiojellyfin
    pytest-aiohttp
    pytest-cov-stub
    pytestCheckHook
    syrupy
    pytest-timeout
  ]
  ++ lib.flatten (lib.attrValues optional-dependencies);

  pytestFlagsArray = [
    # blocks in setup
    "--deselect=tests/server/providers/jellyfin/test_init.py::test_initial_sync"
  ];

  pythonImportsCheck = [ "music_assistant" ];

  passthru = {
    inherit
      python
      pythonPath
      providerPackages
      providerNames
    ;
    tests = nixosTests.music-assistant;
  };

  meta = with lib; {
    changelog = "https://github.com/music-assistant/server/releases/tag/${version}";
    description = "Music Assistant is a music library manager for various music sources which can easily stream to a wide range of supported players";
    longDescription = ''
      Music Assistant is a free, opensource Media library manager that connects to your streaming services and a wide
      range of connected speakers. The server is the beating heart, the core of Music Assistant and must run on an
      always-on device like a Raspberry Pi, a NAS or an Intel NUC or alike.
    '';
    homepage = "https://github.com/music-assistant/server";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
    mainProgram = "mass";
  };
}
