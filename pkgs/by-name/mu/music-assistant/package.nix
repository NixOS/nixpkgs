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

      music-assistant-models = super.music-assistant-models.overridePythonAttrs (oldAttrs: {
        version = "1.1.115";

        src = oldAttrs.src.override {
          hash = "sha256-oEXL0B8JNH4PcltpES375ov7QGs+gtYKlMGr1B7BlKY=";
        };
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
  (lib.elem "ariacast" providers) -> throw "music-assistant: ariacast has not been packaged, yet.";

python.pkgs.buildPythonApplication rec {
  pname = "music-assistant";
  version = "2.8.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "music-assistant";
    repo = "server";
    tag = version;
    hash = "sha256-//SR7UhaDgT6zNBZ6/B0tBQ88fWkHtrr9Ds0KwH6xzs=";
  };

  patches = [
    (replaceVars ./ffmpeg.patch {
      ffmpeg = "${lib.getBin ffmpeg_7-headless}/bin/ffmpeg";
      ffprobe = "${lib.getBin ffmpeg_7-headless}/bin/ffprobe";
    })

    # Look up librespot from PATH at runtime
    ./librespot.patch

    # Look up shairport-sync from PATH at runtime
    ./shairport-sync.patch

    # Look up cliraop/cliap2 from PATH at runtime
    ./cliraop-cliap2.patch

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
      --replace-fail "0.0.0" "${version}" \
      --replace-fail "==" ">="

    rm -rv \
      music_assistant/providers/airplay/bin/{cliap2-*,cliraop-*} \
      music_assistant/providers/airplay_receiver/bin/{build_binaries.sh,shairport-sync-*} \
      music_assistant/providers/ariacast_receiver/bin/ariacast_* \
      music_assistant/providers/spotify/bin/librespot-*

    found_bins=$(find music_assistant/ -wholename '*/bin/*' -type f -executable -print0 | tr '\0' ' ')
    if [[ -n $found_bins ]]; then
      echo "Found binaries that should be replaced with packages built from source: $found_bins"
      exit 2
    fi
  '';

  build-system = with python.pkgs; [
    setuptools
  ];

  pythonRelaxDeps = [
    "aiohttp"
    "aiosqlite"
    "cryptography"
    "mashumaro"
    "orjson"
    "xmltodict"
  ];

  pythonRemoveDeps = [
    # no runtime dependency resolution
    "uv"
  ];

  dependencies =
    with python.pkgs;
    [
      # Only packages required in pyproject.toml
      aiodns
      aiofiles
      aiohttp
      aiohttp-asyncmdnsresolver
      aiohttp-fast-zlib
      aiohttp-socks
      aiortc
      aiosqlite
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
      numpy
      orjson
      pillow
      podcastparser
      propcache
      pyjwt
      python-slugify
      shortuuid
      unidecode
      xmltodict
      zeroconf

      # Used in music_assistant/controllers/webserver/helpers/auth_providers.py
      # but somehow not part of pyproject.toml
      hass-client
    ]
    ++ gql.optional-dependencies.all
    ++ pyjwt.optional-dependencies.crypto;

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
    ++ (providerPackages.audible python.pkgs)
    ++ (providerPackages.dlna python.pkgs)
    ++ (providerPackages.jellyfin python.pkgs)
    ++ (providerPackages.opensubsonic python.pkgs)
    ++ (providerPackages.sendspin python.pkgs)
    ++ (providerPackages.tidal python.pkgs);

  disabledTestPaths = [
    # no multicast support in build sandbox:
    # "OSError: [Errno 19] No such device"
    "tests/core/test_genres.py"
    # provider is missing dependencies
    "tests/providers/apple_music"
    "tests/providers/bandcamp"
    "tests/providers/kion_music"
    "tests/providers/nicovideo"
    "tests/providers/yandex_music"
    "tests/providers/zvuk_music"
    # mocking music_assistant.providers.airplay.pairing.AirPlayPairing does not work
    "tests/providers/airplay/test_player.py::test_start_pairing__pin_decision"
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
