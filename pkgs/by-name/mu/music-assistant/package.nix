{
  lib,
  python3,
  fetchFromGitHub,
  ffmpeg-headless,
  librespot,
  nixosTests,
  replaceVars,
  providers ? [ ],
}:

let
  python = python3.override {
    self = python;
    packageOverrides = self: super: {
      music-assistant-frontend = self.callPackage ./frontend.nix { };

      music-assistant-models = super.music-assistant-models.overridePythonAttrs (oldAttrs: rec {
        version = "1.1.30";

        src = fetchFromGitHub {
          owner = "music-assistant";
          repo = "models";
          tag = version;
          hash = "sha256-ZLTRHarjVFAk+tYPkgLm192rE+C82vNzqs8PmJhGSeg=";
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
  version = "2.4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "music-assistant";
    repo = "server";
    tag = version;
    hash = "sha256-5FIIXIn4tEz6w/uAh6PGkU4tU+mz7Jpb3+bq1mRNr2Y=";
  };

  patches = [
    (replaceVars ./ffmpeg.patch {
      ffmpeg = "${lib.getBin ffmpeg-headless}/bin/ffmpeg";
      ffprobe = "${lib.getBin ffmpeg-headless}/bin/ffprobe";
    })
    (replaceVars ./librespot.patch {
      librespot = lib.getExe librespot;
    })

    # Disable interactive dependency resolution, which clashes with the immutable Python environment
    ./dont-install-deps.patch
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "0.0.0" "${version}"

    rm -rv music_assistant/providers/spotify/bin
  '';

  build-system = with python.pkgs; [
    setuptools
  ];

  pythonRelaxDeps = [
    "aiohttp"
    "aiosqlite"
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
      mutagen
      orjson
      pillow
      podcastparser
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
      pytest-aiohttp
      pytest-cov-stub
      pytest-timeout
      pytestCheckHook
      syrupy
      pytest-timeout
    ]
    ++ lib.flatten (lib.attrValues optional-dependencies)
    ++ (providerPackages.jellyfin python.pkgs)
    ++ (providerPackages.opensubsonic python.pkgs);

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
