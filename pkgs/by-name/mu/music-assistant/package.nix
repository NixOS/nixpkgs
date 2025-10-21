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
      music-assistant-frontend = self.callPackage ./frontend.nix { };

      music-assistant-models = super.music-assistant-models.overridePythonAttrs (oldAttrs: rec {
        version = "1.1.47";

        src = fetchFromGitHub {
          owner = "music-assistant";
          repo = "models";
          tag = version;
          hash = "sha256-NNKF61CRBe+N9kY+JUa77ClHSJ9RhpsiheMg7Ytyq2M=";
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

assert
  (lib.elem "airplay" providers)
  -> throw "music-assistant: airplay support is missing libraop, a library we will not package because it depends on OpenSSL 1.1.";

python.pkgs.buildPythonApplication rec {
  pname = "music-assistant";
  version = "2.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "music-assistant";
    repo = "server";
    tag = version;
    hash = "sha256-e596gvj+ZZDQzyBVfI50nO0a0eZifrkQVhUNNP2Jj8A=";
  };

  patches = [
    (replaceVars ./ffmpeg.patch {
      ffmpeg = "${lib.getBin ffmpeg-headless}/bin/ffmpeg";
      ffprobe = "${lib.getBin ffmpeg-headless}/bin/ffprobe";
    })

    # Look up librespot from PATH at runtime
    ./librespot.patch

    # Disable interactive dependency resolution, which clashes with the immutable Python environment
    ./dont-install-deps.patch

    # Fix running the built-in snapcast server
    ./builtin-snapcast-server.patch
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

  pythonRemoveDeps = [
    # no runtime dependency resolution
    "uv"
  ];

  dependencies =
    with python.pkgs;
    [
      aiohttp
      chardet
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

  disabledTestPaths = [
    # blocks in poll()
    "tests/providers/jellyfin/test_init.py::test_initial_sync"
    "tests/core/test_server_base.py::test_start_and_stop_server"
    "tests/core/test_server_base.py::test_events"
    # not compatible with the required py-subsonic version
    "tests/providers/opensubsonic/test_parsers.py"
  ];

  pythonImportsCheck = [ "music_assistant" ];

  postFixup = ''
    # binary native code, segfaults when autopatchelf'd, requires openssl 1.1 to build
    rm $out/${python3.sitePackages}/music_assistant/providers/airplay/bin/cliraop-*
  '';

  passthru = {
    inherit
      python
      pythonPath
      providerPackages
      providerNames
      ;
    tests = nixosTests.music-assistant;
  };

  meta = {
    changelog = "https://github.com/music-assistant/server/releases/tag/${version}";
    description = "Music Assistant is a music library manager for various music sources which can easily stream to a wide range of supported players";
    longDescription = ''
      Music Assistant is a free, opensource Media library manager that connects to your streaming services and a wide
      range of connected speakers. The server is the beating heart, the core of Music Assistant and must run on an
      always-on device like a Raspberry Pi, a NAS or an Intel NUC or alike.
    '';
    homepage = "https://github.com/music-assistant/server";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hexa ];
    mainProgram = "mass";
  };
}
