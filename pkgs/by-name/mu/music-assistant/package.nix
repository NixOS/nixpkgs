{
  lib,
  stdenv,
  airplay-cli,
  python3Packages,
  fetchFromGitHub,
  ffmpeg_7-headless,
  nixosTests,
  openssl,
  replaceVars,
  writableTmpDirAsHomeHook,
  providers ? [ ],
}:

let
  pythonPackages = python3Packages.overrideScope (
    final: prev: {
      # TODO: package properly when no longer using a fork
      aiolibdatachannel = final.callPackage ./aiolibdatachannel.nix { };

      music-assistant-frontend = final.callPackage ./frontend.nix { };

      music-assistant-models = prev.music-assistant-models.overridePythonAttrs (oldAttrs: {
        version = "1.1.204";

        src = oldAttrs.src.override {
          hash = "sha256-nmIBjdKcgiRBJJSfPrd8lGt940/u9e3Uu//1A6Q68EY=";
        };
      });
    }
  );

  # 6.0.0.post1 causes 10+ tests to fail with encoding errors
  # Overwriting chardet for the package set causes many rebuilds and failures in other packages,
  # but luckily nothing is propagating it, so we can get away with only overlaying it for music-assistant
  chardet = pythonPackages.chardet.overridePythonAttrs (
    { src, meta, ... }:
    let
      version = "7.6.0";
    in
    {
      inherit version;
      src = src.override {
        hash = "sha256-7xloMYaoAB1uwj4/5KK8PFd/mjXTgMFjS0SGW7Rrynw=";
      };

      nativeCheckInputs = with pythonPackages; [
        pytestCheckHook
      ];

      preCheck = ''
        ln -s ${
          fetchFromGitHub {
            owner = "chardet";
            repo = "test-data";
            tag = version;
            hash = "sha256-kgD/fCxVuxgn6x2JVf4ij8ptzRi7AfqswccQ0akWL0s=";
          }
        } tests/data
      '';

      meta = meta // {
        license = lib.licenses.bsd0;
      };
    }
  );

  providersMeta = import ./providers.nix;
  providerPackages = providersMeta.providers;
  providerNames = lib.attrNames providerPackages;
  providerDependencies = lib.concatMap (
    provider: (providerPackages.${provider} pythonPackages)
  ) providers;
in

assert
  (lib.elem "ariacast" providers) -> throw "music-assistant: ariacast has not been packaged, yet.";

pythonPackages.buildPythonApplication (finalAttrs: {
  pname = "music-assistant";
  version = "2.10.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "music-assistant";
    repo = "server";
    tag = finalAttrs.version;
    hash = "sha256-6Fyi2FZp7sFTXpgxX0yYpzai8TSPqR5YkCb8jJiRtlY=";
  };

  patches = [
    (replaceVars ./ffmpeg.patch {
      ffmpeg = lib.getExe' ffmpeg_7-headless "ffmpeg";
      ffprobe = lib.getExe' ffmpeg_7-headless "ffprobe";
    })

    # Look up librespot from PATH at runtime
    ./librespot.patch

    # Look up shairport-sync from PATH at runtime
    ./shairport-sync.patch

    # Look up cliairplay from PATH at runtime
    ./cliairplay.patch

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

    # As providers must be configured through the nixos module, there is no gain
    # if Music Assistant tries to enable some of them without the proper dependencies.
    ./disable-default-provider.diff

    # Fixes this warning on startup:
    #  On-device ML inference capability probe was inconclusive (exit code 1); assuming this CPU is capable
    # Music-Assistant's site-packages is injected via passthru.pythonPath, because $out cannot be used with replaceVars
    ./inherit-env-for-avx2-check.diff
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "0.0.0" "${finalAttrs.version}" \
      --replace-fail "==" ">="

    rm -rv \
      music_assistant/providers/airplay_receiver/bin/{build_binaries.sh,shairport-sync-*} \
      music_assistant/providers/spotify/bin/librespot-*

    found_bins=$(find music_assistant/ -wholename '*/bin/*' -type f -executable -print0 | tr '\0' ' ')
    if [[ -n $found_bins ]]; then
      echo "Found binaries that should be replaced with packages built from source: $found_bins"
      exit 2
    fi

    airplay_cli_version=$(grep -oP 'CLIAIRPLAY_VERSION=v\K[0-9]+\.[0-9]+\.[0-9]+' Dockerfile)
    if [[ $airplay_cli_version != ${airplay-cli.version} ]]; then
      echo "Our airplay-cli version ${airplay-cli.version} is not matching upstream $airplay_cli_version, please update it!"
      exit 5
    fi
  '';

  build-system = with pythonPackages; [
    setuptools
  ];

  pythonRelaxDeps = [
    "aiosqlite"
    "cryptography"
    "torch"
  ];

  pythonRemoveDeps = [
    # no runtime dependency resolution
    "uv"
  ];

  dependencies =
    with pythonPackages;
    [
      # Only packages required in pyproject.toml
      aiodns
      aiofiles
      aiohttp
      aiohttp-asyncmdnsresolver
      aiohttp-fast-zlib
      aiohttp-socks
      aiolibdatachannel
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
      markdownify
      mashumaro
      modern-colorthief
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
      torch
      torchaudio
      unidecode
      xmltodict
      zeroconf

      # Used in music_assistant/controllers/webserver/helpers/auth_providers.py
      # but somehow not part of pyproject.toml
      hass-client
    ]
    ++ gql.optional-dependencies.all
    ++ pyjwt.optional-dependencies.crypto;

  optional-dependencies = with pythonPackages; {
    # Required subset of optional-dependencies in pyproject.toml
    test = [
      pytest-aiohttp
      pytest-cov-stub
      pytest-timeout
      pytest-xdist
      syrupy
    ];
  };

  nativeCheckInputs =
    with pythonPackages;
    [
      ffmpeg_7-headless
      openssl
      pytest9_0CheckHook
      writableTmpDirAsHomeHook
    ]
    ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies
    ++ (lib.concatMap (provider: providerPackages.${provider} pythonPackages) [
      "acoustid_lookup"
      "airplay"
      "apple_music"
      "audible"
      "audiobookshelf"
      "bluesound"
      "chromecast"
      "dlna"
      "fastmcp_server"
      "filesystem_google_drive"
      "filesystem_onedrive"
      "fully_kiosk"
      "heos"
      "jellyfin"
      "local_audio"
      "mpd"
      "msx_bridge"
      "opensubsonic"
      "plex"
      "plex_connect"
      "profiler"
      "sendspin"
      "sendspin"
      "smart_fades"
      "snapcast"
      "sonic_analysis"
      "sonic_similarity"
      "sonos"
      "sonos_s1"
      "soundcloud"
      "spotify"
      "squeezelite"
      "tidal"
      "vban_receiver"
      "ytmusic"
    ]);

  preCheck = ''
    export NUMBA_CACHE_DIR=$(mktemp -d)

    # required for smart_fades tests
    mkdir -p $HOME/.cache/torch/hub/checkpoints/
    cp ${pythonPackages.beat-this.passthru.small0Ckpt} $HOME/.cache/torch/hub/checkpoints/beat_this-small0.ckpt
  '';

  disabledTestPaths = [
    # provider is missing dependencies
    "tests/providers/amplipi"
    "tests/providers/bandcamp"
    "tests/providers/bbc_sounds"
    "tests/providers/deezer"
    "tests/providers/hue_entertainment"
    "tests/providers/kion_music"
    "tests/providers/nicovideo"
    "tests/providers/qqmusic"
    "tests/providers/siriusxm"
    "tests/providers/stream_limits"
    "tests/providers/wiim"
    "tests/providers/yandex_music"
    "tests/providers/yandex_smarthome"
    "tests/providers/yandex_station"
    "tests/providers/yandex_ynison"
    "tests/providers/zvuk_music"
    # hue_entertainment is not packaged
    "tests/controllers/config/test_setup_flows.py::test_hue_pairing_flow_retry_then_success"
    # Our patches break this test
    "tests/helpers/test_util.py::TestLoadProviderModule"
    "tests/providers/airplay/test_helpers.py::test_get_cli_binary_uses_release_asset_name"
    # We do not have a full git repo to work with
    "tests/scripts/test_release_workflow.py"
    # save compute
    "tests/benchmarks/test_bench_helpers.py"
  ];

  disabledTests = lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
    # RuntimeError: failed to initialize QNNPACK
    "test_beat_detection"
    "test_extended_analysis_fields"
    "test_finalize_returns_audio_analysis_data"
    "test_finalize_returns_none_on_early_exit"
  ];

  pythonImportsCheck = [ "music_assistant" ];

  passthru = {
    ffmpeg = ffmpeg_7-headless;
    inherit
      pythonPackages
      providerPackages
      providerNames
      ;
    providersBuiltins = providersMeta.builtins;
    pythonPath =
      pythonPackages.makePythonPath providerDependencies
      + ":${finalAttrs.finalPackage}/${pythonPackages.python.sitePackages}";
    tests = nixosTests.music-assistant;
  };

  meta = {
    broken = stdenv.hostPlatform.isDarwin;
    changelog = "https://github.com/music-assistant/server/releases/tag/${finalAttrs.src.tag}";
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
})
