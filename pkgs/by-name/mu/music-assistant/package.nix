{
  lib,
  python3,
  fetchFromGitHub,
  ffmpeg-headless,
  nixosTests,
  replaceVars,
  providers ? [ ],
}:

let
  python = python3.override {
    self = python;
    packageOverrides = self: super: {
      aiojellyfin = super.aiojellyfin.overridePythonAttrs (oldAttrs: rec {
        version = "0.10.1";

        src = fetchFromGitHub {
          owner = "Jc2k";
          repo = "aiojellyfin";
          tag = "v${version}";
          hash = "sha256-A+uvM1/7HntRMIdknfHr0TMGIjHk7BCwsZopXdVoEO8=";
        };
      });

      music-assistant-frontend = self.callPackage ./frontend.nix { };

      music-assistant-models = super.music-assistant-models.overridePythonAttrs (oldAttrs: rec {
        version = "1.1.4";

        src = fetchFromGitHub {
          owner = "music-assistant";
          repo = "models";
          tag = version;
          hash = "sha256-keig18o32X53q/QcoaPO0o9AT4XTEZ+dQ3L6u6BVkLU=";
        };

        postPatch = ''
          substituteInPlace pyproject.toml \
            --replace-fail "0.0.0" "${version}"
        '';
      });
    };
  };

  providerPackages = (import ./providers.nix).providers;
  providerNames = lib.attrNames providerPackages;
  providerDependencies = lib.concatMap (
    provider: (providerPackages.${provider} python.pkgs)
  ) providers;

  pythonPath = python.pkgs.makePythonPath providerDependencies;
in

python.pkgs.buildPythonApplication rec {
  pname = "music-assistant";
  version = "2.3.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "music-assistant";
    repo = "server";
    tag = version;
    hash = "sha256-CSGpG1E4ou1TGz/S1mXFHyk49p7dStEwxUTB+xxfNEc=";
  };

  patches = [
    (replaceVars ./ffmpeg.patch {
      ffmpeg = "${lib.getBin ffmpeg-headless}/bin/ffmpeg";
      ffprobe = "${lib.getBin ffmpeg-headless}/bin/ffprobe";
    })

    # Disable interactive dependency resolution, which clashes with the immutable Python environment
    ./dont-install-deps.patch
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "0.0.0" "${version}"
  '';

  build-system = with python.pkgs; [
    setuptools
  ];

  pythonRelaxDeps = [
    "aiohttp"
    "certifi"
    "colorlog"
    "cryptography"
    "mashumaro"
    "orjson"
    "pillow"
    "xmltodict"
    "zeroconf"
  ];

  dependencies =
    with python.pkgs;
    [
      aiohttp
      mashumaro
      orjson
    ]
    ++ optional-dependencies.server;

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
      music-assistant-models
      orjson
      pillow
      python-slugify
      shortuuid
      unidecode
      xmltodict
      zeroconf
    ];
  };

  nativeCheckInputs =
    with python.pkgs;
    [
      aiojellyfin
      pytest-aiohttp
      pytest-cov-stub
      pytest-timeout
      pytestCheckHook
      syrupy
      pytest-timeout
    ]
    ++ lib.flatten (lib.attrValues optional-dependencies);

  pytestFlagsArray = [
    # blocks in poll()
    "--deselect=tests/providers/jellyfin/test_init.py::test_initial_sync"
    "--deselect=tests/core/test_server_base.py::test_start_and_stop_server"
    "--deselect=tests/core/test_server_base.py::test_events"
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
