{
  lib,
  python3,
  fetchFromGitHub,
  ffmpeg_7-headless,
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
        version = "1.1.86";

        src = fetchFromGitHub {
          owner = "music-assistant";
          repo = "models";
          tag = version;
          hash = "sha256-dQwFsuelp/3s2CO/5jxNrZcmWxE9xYhrpx0O37Tq/TQ=";
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
  version = "2.7.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "music-assistant";
    repo = "server";
    tag = version;
    hash = "sha256-c6WTalpjaZcUvppyYaTP03ErX5b+k7fUbphj58FVBS8=";
  };

  patches = [
    (replaceVars ./ffmpeg.patch {
      ffmpeg = "${lib.getBin ffmpeg_7-headless}/bin/ffmpeg";
      ffprobe = "${lib.getBin ffmpeg_7-headless}/bin/ffprobe";
    })

    # Look up librespot from PATH at runtime
    ./librespot.patch

    # Disable interactive dependency resolution, which clashes with the immutable Python environment
    ./dont-install-deps.patch

    # Fix running the built-in snapcast server
    ./builtin-snapcast-server.patch

    # Fix running the webserver pytests in our nix sandbox, which only has a loopback interface,
    # by not skipping over its loopback IPv4 address:
    #
    #     """Return all Config Entries for this core module (if any)."""
    #     ip_addresses = await get_ip_addresses()
    # >   default_publish_ip = ip_addresses[0]
    #                          ^^^^^^^^^^^^^^^
    # E   IndexError: tuple index out of range
    ./fix-webserver-tests-in-sandbox.patch
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "0.0.0" "${version}"

    # get-mac is a deprecated alias of getmac since 2018
    substituteInPlace pyproject.toml \
      --replace-fail "get-mac" "getmac"

    rm -rv music_assistant/providers/spotify/bin
  '';

  build-system = with python.pkgs; [
    setuptools
  ];

  pythonRelaxDeps = [
    "aiofiles"
    "aiohttp"
    "aiosqlite"
    "certifi"
    "colorlog"
    "cryptography"
    "getmac"
    "mashumaro"
    "orjson"
    "pillow"
    "podcastparser"
    "pycares"
    "xmltodict"
    "zeroconf"
  ];

  pythonRemoveDeps = [
    # no runtime dependency resolution
    "uv"
  ];

  dependencies = with python.pkgs; [
    # Only packages required in pyproject.toml
    aiodns
    aiofiles
    aiohttp
    aiohttp-asyncmdnsresolver
    aiohttp-fast-zlib
    aiortc
    aiorun
    aiosqlite
    aiovban
    awesomeversion
    brotli
    certifi
    chardet
    colorlog
    cryptography
    getmac
    gql
    ifaddr
    librosa
    mashumaro
    music-assistant-frontend
    music-assistant-models
    mutagen
    orjson
    pillow
    podcastparser
    propcache
    python-slugify
    shortuuid
    unidecode
    xmltodict
    zeroconf

    # Used in music_assistant/controllers/webserver/helpers/auth_providers.py
    # but somehow not part of pyproject.toml
    hass-client
  ];

  optional-dependencies = with python.pkgs; {
    # Required subset of optional-dependencies in pyproject.toml
    test = [
      pytest-aiohttp
      pytest-cov-stub
      syrupy
    ];
  };

  nativeCheckInputs =
    with python.pkgs;
    [
      pytestCheckHook
    ]
    ++ lib.concatAttrValues optional-dependencies
    ++ (providerPackages.jellyfin python.pkgs)
    ++ (providerPackages.opensubsonic python.pkgs)
    ++ (providerPackages.tidal python.pkgs);

  disabledTestPaths = [
    # no multicast support in build sandbox:
    # "OSError: [Errno 19] No such device"
    "tests/providers/jellyfin/test_init.py::test_initial_sync"
    "tests/core/test_server_base.py::test_start_and_stop_server"
    "tests/core/test_server_base.py::test_events"
    # provider is missing dependencies
    "tests/providers/nicovideo"
    "tests/providers/apple_music"
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
    maintainers = with lib.maintainers; [
      hexa
      emilylange
    ];
    mainProgram = "mass";
  };
}
