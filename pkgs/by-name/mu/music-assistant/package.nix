{
  lib,
  stdenv,
  airplay-cli,
  python3Packages,
  fetchFromGitHub,
  ffmpeg_9-headless,
  nixosTests,
  openssl,
  replaceVars,
  writableTmpDirAsHomeHook,
  writers,
  providers ? [ ],
}:

let
  pythonPackages = python3Packages.overrideScope (
    final: prev: {
      # TODO: package properly when no longer using a fork
      aiolibdatachannel = final.callPackage ./aiolibdatachannel.nix { };

      fastmcp = final.fastmcp_4;

      fastmcp-slim = final.fastmcp-slim_4;

      music-assistant-frontend = final.callPackage ./frontend.nix { };

      music-assistant-models = prev.music-assistant-models.overridePythonAttrs (oldAttrs: {
        version = "1.1.251";

        src = oldAttrs.src.override {
          hash = "sha256-XD8/RADymU4x9dZaEy6AQNCHZcTTE6QS5bPDZ2WrhD8=";
        };
      });

      pydantic-monty = final.pydantic-monty_1;
    }
  );

  inherit (import ./providers.nix)
    builtinProviders
    providerDependencies
    providerPackages
    providersWithMissingDependencies
    ;
  providerNames = lib.attrNames providerPackages;
  providersWithDependencies = lib.unique (
    providers ++ lib.concatMap (provider: providerDependencies.${provider} or [ ]) providers
  );
  providerPackageDependencies = lib.concatMap (
    provider: (providerPackages.${provider} pythonPackages)
  ) providersWithDependencies;
in
pythonPackages.buildPythonApplication (finalAttrs: {
  pname = "music-assistant";
  version = "2.11.0b11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "music-assistant";
    repo = "server";
    tag = finalAttrs.version;
    hash = "sha256-a6pnUKd1sKGtqxf3PQShy22bqatO/QuIypQwgWpJly0=";
  };

  patches = [
    (replaceVars ./ffmpeg.patch {
      ffmpeg = lib.getExe' ffmpeg_9-headless "ffmpeg";
      ffprobe = lib.getExe' ffmpeg_9-headless "ffprobe";
    })

    # Look up librespot from PATH at runtime
    ./librespot.patch

    # Look up cliairplay from PATH at runtime
    ./cliairplay.patch

    # Disable interactive dependency resolution, which clashes with the immutable Python environment
    ./dont-install-deps.patch

    # Upstream expects the tests to be run with the version set to 0.0.0
    ./upstream-test-version.patch

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
    ./disable-default-provider.patch
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "==" ">="

    # Let the pythonRuntimeDepsCheckHook validate the frontend version
    sed -i pyproject.toml \
      -Ee 's|"music-assistant-frontend @ https://github.com/music-assistant/frontend/releases/download/([0-9][^/]*).*",|"music-assistant-frontend==\1",|'

    # Mimic an official build to avoid scary looking warnings that the installation method is not supported.
    substituteInPlace music_assistant/helpers/build_info.py \
      --replace-fail 'Path("/app/build_info.json")' 'Path("${
        writers.writeJSON "music-assistant-build-info.json" {
          inherit (finalAttrs) version;
          commit = finalAttrs.src.rev;
          source = "nixpkgs";
        }
      }")'

    rm -rv \
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

  nativeBuildInputs = with pythonPackages; [ pyprojectVersionPatchHook ];

  build-system = with pythonPackages; [
    setuptools
  ];

  pythonRelaxDeps = [
    "aiohttp"
    "aiosqlite"
    "certifi"
    "cryptography"
    "gql"
    "numpy"
    "pillow"
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
      # 6.0.0.post1 causes 10+ tests to fail with encoding errors
      # Overwriting chardet for the package set causes many rebuilds and failures in other packages,
      # but luckily nothing is propagating it, so we can get away with only overlaying it for music-assistant
      chardet_7
      colorlog
      cryptography
      defusedxml
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
      uv
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
      openssl
      pytest9_0CheckHook
      writableTmpDirAsHomeHook
    ]
    ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies
    ++ (lib.concatMap (provider: providerPackages.${provider} pythonPackages) [
      "acoustid_lookup"
      "airplay"
      "alexa"
      "apple_music"
      "audible"
      "audiobookshelf"
      "bandcamp"
      "bluesound"
      "chromecast"
      "dlna"
      "fastmcp_server"
      "filesystem_google_drive"
      "filesystem_onedrive"
      "fully_kiosk"
      "heos"
      "jellyfin"
      "lastfm_scrobble"
      "listenbrainz_scrobble"
      "local_audio"
      "mpd"
      "msx_bridge"
      "musiccast"
      "opensubsonic"
      "plex"
      "plex_connect"
      "profiler"
      "roku_media_assistant"
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
      "wiim"
      "yoto"
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
    "tests/providers/bbc_sounds"
    "tests/providers/deezer"
    "tests/providers/filesystem_yandex_disk"
    "tests/providers/genius_lyrics"
    "tests/providers/hue_entertainment"
    "tests/providers/ibroadcast"
    "tests/providers/kion_music"
    "tests/providers/lifx_entertainment"
    "tests/providers/nicovideo"
    "tests/providers/qqmusic"
    "tests/providers/samsung_wam"
    "tests/providers/siriusxm"
    "tests/providers/yandex_music"
    "tests/providers/yandex_smarthome"
    "tests/providers/yandex_station"
    "tests/providers/yandex_ynison"
    "tests/providers/zvuk_music"
    # Cannot succeed, since we do not have all dependencies packaged
    "tests/models/test_player_provider.py::test_no_player_provider_replaces_the_features_of_the_base_class"
    "tests/test_provider_manifests.py"
    # Would require not setting PYTHONPATH
    "tests/controllers/community_catalog/test_dependencies.py::test_clash_with_server"
    "tests/controllers/community_catalog/test_dependencies.py::test_server_package_is_not_installed"
    "tests/controllers/community_catalog/test_dependencies.py::test_sync_removes_what_the_lock_no_longer_has"
    "tests/controllers/community_catalog/test_dependencies.py::test_version_that_needs_another_server_package_is_passed_over"
    # hue_entertainment is not packaged
    "tests/controllers/config/test_setup_flows.py::test_hue_pairing_flow_retry_then_success"
    # sounds is not packaged
    "tests/providers/stream_limits/test_stream_limits.py"
    # Our patches break those tests
    "tests/helpers/test_util.py::TestLoadProviderModule"
    "tests/providers/airplay/test_helpers.py::test_get_cli_binary_uses_release_asset_name"
    "tests/providers/ytmusic/test_ytmusic.py::test_install_packages"
    # We do not have a full git repo to work with
    "tests/scripts/test_dev_image.py::test_dev_app_bump"
    "tests/scripts/test_release_workflow.py"
    # timing sensitive and racy tests
    "tests/controllers/music/test_music_migrations.py::test_migrate_database_backfills_external_id_lookup"
    "tests/controllers/players/test_player_controller.py::TestReleaseWaitForPlayMedia::test_plays_as_soon_as_the_player_reports_its_leave"
    "tests/helpers/test_tags.py::test_async_parse_tags_reaps_hanging_process"
    "tests/providers/playlist_metadata/test_ai.py::test_an_unreachable_engine_is_retried_far_longer"
    "tests/providers/sendspin/test_dsp_channel_alignment.py"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
    # Timing sensitive
    "tests/controllers/music/test_recommendations.py::test_library_row_items_thread_providers_into_underlying_query"
    "tests/controllers/streams/test_audio_buffer.py::test_seekable_no_eviction_after_eof"
  ];

  pythonImportsCheck = [ "music_assistant" ];

  passthru = {
    inherit
      builtinProviders
      providerNames
      providerDependencies
      providerPackages
      providersWithMissingDependencies
      pythonPackages
      ;
    pythonPath =
      pythonPackages.makePythonPath (finalAttrs.passthru.dependencies ++ providerPackageDependencies)
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
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
    mainProgram = "mass";
  };
})
