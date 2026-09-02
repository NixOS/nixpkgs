{
  lib,
  beamPackages,
  cmake,
  extend,
  lexbor,
  fetchFromGitHub,
  oniguruma,
  overrides ? (x: y: { }),
  overrideFenixOverlay ? null,
  rustlerPrecompiledOverrides ? { },
  stdenv,
  pkg-config,
  vips,
  writeText,
}:

let
  buildMix = lib.makeOverridable beamPackages.buildMix;
  buildRebar3 = lib.makeOverridable beamPackages.buildRebar3;

  workarounds = {
    portCompiler = _unusedArgs: old: {
      buildPlugins = [ beamPackages.pc ];
    };

    rustlerPrecompiled =
      {
        toolchain ? null,
        buildInputs ? [ ],
        nativeBuildInputs ? [ ],
        env ? { },
        ...
      }:
      old:
      let
        extendedPkgs = extend fenixOverlay;
        fenixOverlay =
          if overrideFenixOverlay == null then
            import "${
              fetchTarball {
                url = "https://github.com/nix-community/fenix/archive/6399553b7a300c77e7f07342904eb696a5b6bf9d.tar.gz";
                sha256 = "sha256-C6tT7K1Lx6VsYw1BY5S3OavtapUvEnDQtmQB5DSgbCc=";
              }
            }/overlay.nix"
          else
            overrideFenixOverlay;
        nativeDir = "${old.src}/native/${with builtins; head (attrNames (readDir "${old.src}/native"))}";
        fenix =
          if toolchain == null then
            extendedPkgs.fenix.stable
          else
            extendedPkgs.fenix.fromToolchainName toolchain;
        native =
          (
            (extendedPkgs.makeRustPlatform {
              inherit (fenix) cargo rustc;
            }).buildRustPackage
            {
              inherit env buildInputs;
              pname = "${old.beamModuleName}-native";
              version = old.version;
              src = nativeDir;
              cargoLock = {
                lockFile = "${nativeDir}/Cargo.lock";
              };
              nativeBuildInputs = [ extendedPkgs.cmake ] ++ nativeBuildInputs;
              doCheck = false;
            }
          ).overrideAttrs
            rustlerPrecompiledOverrides.${old.beamModuleName} or { };

      in
      {
        nativeBuildInputs = [ extendedPkgs.cargo ];

        env.RUSTLER_PRECOMPILED_FORCE_BUILD_ALL = "true";
        env.RUSTLER_PRECOMPILED_GLOBAL_CACHE_PATH = "unused-but-required";

        preConfigure = ''
          mkdir -p priv/native
          for lib in ${native}/lib/*
          do
            dest="$(basename "$lib")"
            if [[ "''${dest##*.}" = "dylib" ]]
            then
              dest="''${dest%.dylib}.so"
            fi
            ln -s "$lib" "priv/native/$dest"
          done
        '';

        preBuild = ''
          suggestion() {
            echo "***********************************************"
            echo "                 deps_nix                      "
            echo
            echo " Rust dependency build failed.                 "
            echo
            echo " If you saw network errors, you might need     "
            echo " to disable compilation on the appropriate     "
            echo " RustlerPrecompiled module in your             "
            echo " application config.                           "
            echo
            echo " We think you need this:                       "
            echo
            echo -n " "
            grep -Rl 'use RustlerPrecompiled' lib \
              | xargs grep 'defmodule' \
              | sed 's/defmodule \(.*\) do/config :${old.beamModuleName}, \1, skip_compilation?: true/'
            echo "***********************************************"
            exit 1
          }
          trap suggestion ERR
        '';
      };

    elixirMake = _unusedArgs: old: {
      preConfigure = ''
        export ELIXIR_MAKE_CACHE_DIR="$TEMPDIR/elixir_make_cache"
      '';
    };

    lazyHtml = _unusedArgs: old: {
      preConfigure = ''
        export ELIXIR_MAKE_CACHE_DIR="$TEMPDIR/elixir_make_cache"
      '';

      postPatch = ''
        substituteInPlace mix.exs \
          --replace-fail "Fine.include_dir()" '"${packages.fine}/src/c_include"' \
          --replace-fail '@lexbor_git_sha "244b84956a6dc7eec293781d051354f351274c46"' '@lexbor_git_sha ""'
      '';

      preBuild = ''
        install -Dm644           -t _build/c/third_party/lexbor/$LEXBOR_GIT_SHA/build           ${lexbor}/lib/liblexbor_static.a
      '';
    };
  };

  defaultOverrides = (
    final: prev:

    let
      apps = {
        crc32cer = [
          {
            name = "portCompiler";
          }
        ];
        explorer = [
          {
            name = "rustlerPrecompiled";
            toolchain = {
              name = "nightly-2025-06-23";
              sha256 = "sha256-UAoZcxg3iWtS+2n8TFNfANFt/GmkuOMDf7QAE0fRxeA=";
            };
          }
        ];
        snappyer = [
          {
            name = "portCompiler";
          }
        ];
      };

      applyOverrides =
        appName: drv:
        let
          allOverridesForApp = builtins.foldl' (
            acc: workaround: acc // (workarounds.${workaround.name} workaround) drv
          ) { } apps.${appName};

        in
        if builtins.hasAttr appName apps then drv.override allOverridesForApp else drv;

    in
    builtins.mapAttrs applyOverrides prev
  );

  self = packages // (defaultOverrides self packages) // (overrides self packages);

  packages =
    with beamPackages;
    with self;
    {

      absinthe =
        let
          version = "1.10.2";
          drv = buildMix {
            inherit version;
            name = "absinthe";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "absinthe";
              sha256 = "3948d6948c45b5cfd375892e578943eac8642d0a34b15e2a92ffdcdda9d91a22";
            };

            beamDeps = [
              dataloader
              decimal
              nimble_parsec
              opentelemetry_process_propagator
              telemetry
            ];
          };
        in
        drv;

      absinthe_altair =
        let
          version = "2026.5.1";
          drv = buildMix {
            inherit version;
            name = "absinthe_altair";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "absinthe_altair";
              sha256 = "1cba964102e94c7b19d2ba9710523cdee799dcace6cbdfb552012374c953282b";
            };

            beamDeps = [
              absinthe_plug
              plug
            ];
          };
        in
        drv;

      absinthe_client =
        let
          version = "2.0.0";
          drv = buildMix {
            inherit version;
            name = "absinthe_client";
            appConfigPath = ./config;

            src = fetchFromGitHub {
              owner = "bonfire-networks";
              repo = "absinthe_client";
              rev = "2c3fb8dcc628e225b60aedf0d06c0bd47257800d";
              hash = "sha256-92dtEsUG+vdijOrKXHomdd4FzqYTprCWF3PMpU3VQ5Y=";
            };

            beamDeps = [
              absinthe_plug
              absinthe
              decimal
              phoenix
              phoenix_pubsub
              phoenix_html
              phoenix_live_view
            ];
          };
        in
        drv;

      absinthe_error_payload =
        let
          version = "1.2.0";
          drv = buildMix {
            inherit version;
            name = "absinthe_error_payload";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "absinthe_error_payload";
              sha256 = "d9b9201a2710a2c09da7a5a35a2d8aff0b0c9253875ab629c45747e13f4b1e4a";
            };

            beamDeps = [
              absinthe
              ecto
            ];
          };
        in
        drv;

      absinthe_graphql_ws =
        let
          version = "0.3.6";
          drv = buildMix {
            inherit version;
            name = "absinthe_graphql_ws";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "absinthe_graphql_ws";
              sha256 = "ad5e51a17cda917fdb70c1ec4e1d93fbad57edd4f5da4de2a62694b4738fa439";
            };

            beamDeps = [
              absinthe
              absinthe_phoenix
              jason
              markdown_formatter
              phoenix
            ];
          };
        in
        drv;

      absinthe_phoenix =
        let
          version = "2.0.5";
          drv = buildMix {
            inherit version;
            name = "absinthe_phoenix";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "absinthe_phoenix";
              sha256 = "086c6d4a1c32f7444713130d204c87b1b006169f5159026b73f02f7d38ccd05c";
            };

            beamDeps = [
              absinthe
              absinthe_plug
              decimal
              phoenix
              phoenix_html
              phoenix_pubsub
            ];
          };
        in
        drv;

      absinthe_plug =
        let
          version = "1.5.10";
          drv = buildMix {
            inherit version;
            name = "absinthe_plug";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "absinthe_plug";
              sha256 = "489ac1951c8e4128571141c60a0669a720619bc161f801a8c6be8cfaf7ab0979";
            };

            beamDeps = [
              absinthe
              plug
            ];
          };
        in
        drv;

      absinthe_relay =
        let
          version = "1.6.0";
          drv = buildMix {
            inherit version;
            name = "absinthe_relay";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "absinthe_relay";
              sha256 = "32d6397a7af3fd02678ef9bc8e2f574487f14593cb3e4f9110fb1c695d4d2ac0";
            };

            beamDeps = [
              absinthe
              ecto
            ];
          };
        in
        drv;

      acceptor_pool =
        let
          version = "1.0.1";
          drv = buildRebar3 {
            inherit version;
            name = "acceptor_pool";

            src = fetchHex {
              inherit version;
              pkg = "acceptor_pool";
              sha256 = "f172f3d74513e8edd445c257d596fc84dbdd56d2c6fa287434269648ae5a421e";
            };
          };
        in
        drv;

      accessible =
        let
          version = "0.3.0";
          drv = buildMix {
            inherit version;
            name = "accessible";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "accessible";
              sha256 = "13a11b0611ab82f7b9098a88465b5674f729c02bd613216243c123c65f90f296";
            };
          };
        in
        drv;

      activity_pub =
        let
          version = "0.1.0";
          drv = buildMix {
            inherit version;
            name = "activity_pub";
            appConfigPath = ./config;

            src = fetchFromGitHub {
              owner = "bonfire-networks";
              repo = "activity_pub";
              rev = "62cb53d56f60d9e02f6b87db20fdb2ac99fc974d";
              hash = "sha256-loGRcaE9FwPZVE3duaCHYgbFjRxyHQ5NRFdjQPOgHGE=";
            };

            beamDeps = [
              phoenix
              plug_cowboy
              phoenix_ecto
              phoenix_live_dashboard
              phoenix_html_helpers
              ecto_sql
              postgrex
              telemetry_metrics
              telemetry_poller
              jason
              mime
              oban
              tesla
              http_signatures
              remote_ip
              hammer
              cachex
              process_tree
              plug_http_validator
              needle_uid
              arrows
              untangle
              ex_confusables
              json_ld
              rdf
            ];
          };
        in
        drv;

      ansi_to_html =
        let
          version = "0.6.0";
          drv = buildMix {
            inherit version;
            name = "ansi_to_html";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "ansi_to_html";
              sha256 = "864a88bcf76c57cc36c26bc2bc3f0372150f2908bb669e86561e01cb50c1dfd1";
            };

            beamDeps = [
              phoenix_html
              phoenix_html_helpers
            ];
          };
        in
        drv;

      argon2_elixir =
        let
          version = "4.1.3";
          drv = buildMix {
            inherit version;
            name = "argon2_elixir";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "argon2_elixir";
              sha256 = "7c295b8d8e0eaf6f43641698f962526cdf87c6feb7d14bd21e599271b510608c";
            };

            beamDeps = [
              comeonin
              elixir_make
            ];
          };
        in
        drv.override (workarounds.elixirMake { } drv);

      arrows =
        let
          version = "0.2.1";
          drv = buildMix {
            inherit version;
            name = "arrows";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "arrows";
              sha256 = "c3de1ba8f2fd79782bce66d601e6aeded1bcb67e4190858e51da4fe3684ffb9d";
            };
          };
        in
        drv;

      axon =
        let
          version = "0.8.1";
          drv = buildMix {
            inherit version;
            name = "axon";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "axon";
              sha256 = "682a3517489300507ac9345f28341e7fa95bc5b4960d645816074ce551795d37";
            };

            beamDeps = [
              nx
              polaris
              table_rex
            ];
          };
        in
        drv;

      bandit =
        let
          version = "1.12.4";
          drv = buildMix {
            inherit version;
            name = "bandit";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "bandit";
              sha256 = "84513318c5752a2a8017664450f889b47fae5d53d64698ddf1e4fb09a7449e8d";
            };

            beamDeps = [
              hpax
              plug
              telemetry
              thousand_island
              websock
            ];
          };
        in
        drv;

      beam_file =
        let
          version = "0.6.4";
          drv = buildMix {
            inherit version;
            name = "beam_file";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "beam_file";
              sha256 = "3f295dba08a68360903e86be4f183d7fb70f762ee37ee176438dde23ea494431";
            };
          };
        in
        drv;

      benchee =
        let
          version = "1.5.1";
          drv = buildMix {
            inherit version;
            name = "benchee";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "benchee";
              sha256 = "a539301f8dfd4efc5c5123bfb9d47ebde20092a863a5b5b16c2a60d2243dfce7";
            };

            beamDeps = [
              deep_merge
              statistex
            ];
          };
        in
        drv;

      blurhash =
        let
          version = "0.1.0";
          drv = buildMix {
            inherit version;
            name = "blurhash";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "rinpatch_blurhash";
              sha256 = "19911a5dcbb0acb9710169a72f702bce6cb048822b12de566ccd82b2cc42b907";
            };

            beamDeps = [
              mogrify
            ];
          };
        in
        drv;

      boltx =
        let
          version = "0.0.6";
          drv = buildMix {
            inherit version;
            name = "boltx";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "boltx";
              sha256 = "576b8f21a2021674130d04cd1fc79a4829a23d2cdf50641b3d7a00ce31b98ead";
            };

            beamDeps = [
              db_connection
              jason
              poison
            ];
          };
        in
        drv;

      bonfire_api_graphql =
        let
          version = "0.2.0";
          drv = buildMix {
            inherit version;
            name = "bonfire_api_graphql";
            appConfigPath = ./config;

            src = fetchFromGitHub {
              owner = "bonfire-networks";
              repo = "bonfire_api_graphql";
              rev = "06fc4e9def2771bf76214a2d3682db5997236ca7";
              hash = "sha256-SwiKl+gnC8FY/OJ5JQJRIOFfKcL/61u5tjNzRuGums0=";
            };

            beamDeps = [
              bonfire_common
              bonfire_ui_common
              absinthe_client
              jason
              redirect
              absinthe
              absinthe_plug
              absinthe_error_payload
              absinthe_phoenix
              absinthe_altair
              geo
              zest
              dataloader
              absinthe_relay
            ];
          };
        in
        drv;

      bonfire_articles =
        let
          version = "0.1.0";
          drv = buildMix {
            inherit version;
            name = "bonfire_articles";
            appConfigPath = ./config;

            src = fetchFromGitHub {
              owner = "bonfire-networks";
              repo = "bonfire_articles";
              rev = "4ef9a9bd3eab6c0b72a9e2225c9aae5554c1fb49";
              hash = "sha256-An1PouOT5yDtetGWCMZLKqIfHTr7Z0KTZEKZ/tQVpgg=";
            };

            beamDeps = [
              bonfire_posts
              bonfire_ui_social
              bonfire_api_graphql
              absinthe
            ];
          };
        in
        drv;

      bonfire_boundaries =
        let
          version = "0.1.0";
          drv = buildMix {
            inherit version;
            name = "bonfire_boundaries";
            appConfigPath = ./config;

            src = fetchFromGitHub {
              owner = "bonfire-networks";
              repo = "bonfire_boundaries";
              rev = "af1014493a021aaeb079da465d363d0dda3e2492";
              hash = "sha256-OCnohkCplbM6MGZPGcIlaG+d7HPV/mRyx495Q5978XE=";
            };

            beamDeps = [
              bonfire_common
              bonfire_epics
              bonfire_data_access_control
              faker_fork
              jason
              scribe
              ecto_vista
              igniter
              absinthe
              bonfire_api_graphql
            ];
          };
        in
        drv;

      bonfire_classify =
        let
          version = "0.1.0";
          drv = buildMix {
            inherit version;
            name = "bonfire_classify";
            appConfigPath = ./config;

            src = fetchFromGitHub {
              owner = "bonfire-networks";
              repo = "bonfire_classify";
              rev = "5e3612b7317a39ab38dbe8a20c21a0c119954aea";
              hash = "sha256-hbTnYrrujA2mWqf+L80846STk7yYv3YMPBFpyudAGJU=";
            };

            beamDeps = [
              bonfire_common
              bonfire_tag
              faker_fork
              jason
              telemetry_metrics
              telemetry_poller
              absinthe
              bonfire_api_graphql
              bonfire_me
            ];
          };
        in
        drv;

      bonfire_common =
        let
          version = "0.1.0";
          drv = buildMix {
            inherit version;
            name = "bonfire_common";
            appConfigPath = ./config;

            src = fetchFromGitHub {
              owner = "bonfire-networks";
              repo = "bonfire_common";
              rev = "784f6408a2e48fe434d7aec475918fef7bb2a914";
              hash = "sha256-TXjwLFc0XToKZQgseiFIa59LqjNtuY3JFhJURnY4hzI=";
            };

            beamDeps = [
              bonfire_data_identity
              paginator
              ecto_shorts
              exkismet
              arrows
              untangle
              ecto_sparkles
              ecto_sql
              needle
              needle_ulid
              postgrex
              ex_cldr
              ex_cldr_languages
              ex_cldr_plugs
              ex_cldr_dates_times
              ex_cldr_units
              ex_cldr_numbers
              ex_cldr_locale_display
              ex_cldr_territories
              ex_cldr_trans
              gettext
              timex
              recase
              simple_slug
              tesla
              pathex
              json_serde
              jason
              mdex
              lumis
              lazy_html
              html_sanitize_ex
              sizeable
              want
              opentelemetry_api
              git_diff
              beam_file
              faker_fork
              process_tree
              nebulex
              nebulex_local
              nebulex_distributed
              nebulex_disk_lfu
              zest
              sentry
              dataloader
              floki
              emote
              text
              text_corpus_udhr
              bumblebee
              telemetry_metrics
              igniter
            ];
          };
        in
        drv;

      bonfire_data_access_control =
        let
          version = "0.1.0";
          drv = buildMix {
            inherit version;
            name = "bonfire_data_access_control";
            appConfigPath = ./config;

            src = fetchFromGitHub {
              owner = "bonfire-networks";
              repo = "bonfire_data_access_control";
              rev = "cb069379c597ffbaf96edc79d814ffd956a7c22c";
              hash = "sha256-La9LgEaf0ordcd8uq3/5nXDvCjwjQl7a53Pt5/FCD6s=";
            };

            beamDeps = [
              needle
            ];
          };
        in
        drv;

      bonfire_data_activity_pub =
        let
          version = "0.1.0";
          drv = buildMix {
            inherit version;
            name = "bonfire_data_activity_pub";
            appConfigPath = ./config;

            src = fetchFromGitHub {
              owner = "bonfire-networks";
              repo = "bonfire_data_activity_pub";
              rev = "a7ec4be592b3685726a54413cfacd1aaf578d38f";
              hash = "sha256-XAdx4LHE5l3OaI3c6BvAcq9zZMGstMmAI5ASkOHOv7w=";
            };

            beamDeps = [
              untangle
              needle
            ];
          };
        in
        drv;

      bonfire_data_assort =
        let
          version = "0.1.0";
          drv = buildMix {
            inherit version;
            name = "bonfire_data_assort";
            appConfigPath = ./config;

            src = fetchFromGitHub {
              owner = "bonfire-networks";
              repo = "bonfire_data_assort";
              rev = "e3457b7048eb659c226a89142edaeb19f31fcb25";
              hash = "sha256-hmqkug0NJwVJfIRUy3eeiZnLrk2JQOH92b2PMmD2yiQ=";
            };

            beamDeps = [
              needle
              ecto_ranked
            ];
          };
        in
        drv;

      bonfire_data_edges =
        let
          version = "0.1.0";
          drv = buildMix {
            inherit version;
            name = "bonfire_data_edges";
            appConfigPath = ./config;

            src = fetchFromGitHub {
              owner = "bonfire-networks";
              repo = "bonfire_data_edges";
              rev = "bc3d0fc63655b44bf122235f28151a748f4ccbe4";
              hash = "sha256-4BwM8eIkrMijjftPIx1/SrUHe7npZQAN7RGwpuAi/UE=";
            };

            beamDeps = [
              needle
            ];
          };
        in
        drv;

      bonfire_data_identity =
        let
          version = "0.1.0";
          drv = buildMix {
            inherit version;
            name = "bonfire_data_identity";
            appConfigPath = ./config;

            src = fetchFromGitHub {
              owner = "bonfire-networks";
              repo = "bonfire_data_identity";
              rev = "5b42fb6528608e5fefa116df26689d04608eec4c";
              hash = "sha256-KrXuRIWU/XAld3QD0TZ5yofT0/7gW6XA89n6v5DLo3k=";
            };

            beamDeps = [
              bonfire_data_edges
              needle
              untangle
              ecto_sparkles
              json_serde
            ];
          };
        in
        drv;

      bonfire_data_social =
        let
          version = "0.1.0";
          drv = buildMix {
            inherit version;
            name = "bonfire_data_social";
            appConfigPath = ./config;

            src = fetchFromGitHub {
              owner = "bonfire-networks";
              repo = "bonfire_data_social";
              rev = "8f7c9312619e0475aa5a9184d31a3709f0003c87";
              hash = "sha256-FYWv/qroRmB0EqgHkKcgRkv1pIC66ex8hK6MlpY4oCM=";
            };

            beamDeps = [
              bonfire_common
              bonfire_data_edges
              ecto_materialized_path
              arrows
              untangle
              needle
              ex_cldr_trans
            ];
          };
        in
        drv;

      bonfire_ecto =
        let
          version = "0.1.0";
          drv = buildMix {
            inherit version;
            name = "bonfire_ecto";
            appConfigPath = ./config;

            src = fetchFromGitHub {
              owner = "bonfire-networks";
              repo = "bonfire_ecto";
              rev = "b8e1a5b0cfbed53daa234c06cc2fb7216e789305";
              hash = "sha256-KFTBH7/ufkCpkS0P61zZKDzWZLy6LUyOSpR0ibGh3CQ=";
            };

            beamDeps = [
              bonfire_common
              bonfire_epics
            ];
          };
        in
        drv;

      bonfire_editor_milkdown =
        let
          version = "0.0.1";
          drv = buildMix {
            inherit version;
            name = "bonfire_editor_milkdown";
            appConfigPath = ./config;

            src = fetchFromGitHub {
              owner = "bonfire-networks";
              repo = "bonfire_editor_milkdown";
              rev = "7be2ebec1654f3a3182eb718484845239b7d9abe";
              hash = "sha256-y+7Mxk081itWg0h9uv4HSStqA6tDErFB6mTDiFauNZk=";
            };

            beamDeps = [
              bonfire_common
              bonfire_ui_common
              surface
            ];
          };
        in
        drv;

      bonfire_epics =
        let
          version = "0.1.0";
          drv = buildMix {
            inherit version;
            name = "bonfire_epics";
            appConfigPath = ./config;

            src = fetchFromGitHub {
              owner = "bonfire-networks";
              repo = "bonfire_epics";
              rev = "90bc2259a444befe2b75a95bf5f7790c58d95951";
              hash = "sha256-Islp4UkxWmUa7mxHCCZsgKLMRFVOXBL0CwSydUbwI/s=";
            };

            beamDeps = [
              untangle
              arrows
              bonfire_common
            ];
          };
        in
        drv;

      bonfire_fail =
        let
          version = "0.1.0";
          drv = buildMix {
            inherit version;
            name = "bonfire_fail";
            appConfigPath = ./config;

            src = fetchFromGitHub {
              owner = "bonfire-networks";
              repo = "bonfire_fail";
              rev = "7fa5700a7fc8432722fdf680b1780becbc241044";
              hash = "sha256-BRx0qtoXscgVTWdIkUhYCeNUBGm0arzMwfvYpNZoovU=";
            };

            beamDeps = [
              bonfire_common
            ];
          };
        in
        drv;

      bonfire_federate_activitypub =
        let
          version = "0.1.0";
          drv = buildMix {
            inherit version;
            name = "bonfire_federate_activitypub";
            appConfigPath = ./config;

            src = fetchFromGitHub {
              owner = "bonfire-networks";
              repo = "bonfire_federate_activitypub";
              rev = "30ded0da0d885b83a5286e18954f9e4814c6a6a5";
              hash = "sha256-cZKG3f+no5ytkx5Eb9ey8qpkDq/If/6zRLdLI2sBdnQ=";
            };

            beamDeps = [
              bonfire_common
              bonfire_me
              bonfire_social
              activity_pub
              nodeinfo
              faker_fork
              gettext
              jason
              telemetry_metrics
              telemetry_poller
              oban
              bonfire_boundaries
            ];
          };
        in
        drv;

      bonfire_files =
        let
          version = "0.1.0";
          drv = buildMix {
            inherit version;
            name = "bonfire_files";
            appConfigPath = ./config;

            src = fetchFromGitHub {
              owner = "bonfire-networks";
              repo = "bonfire_files";
              rev = "6e9c49f07b42d0a8287d1647512badb300540ddc";
              hash = "sha256-rFYsq7P/0dkiegyenoN6daYFiodSk9KoNatnaxtJpv0=";
            };

            beamDeps = [
              bonfire_common
              bonfire_ui_common
              bonfire_epics
              twinkle_star
              unfurl
              entrepot
              entrepot_ecto
              waffle
              ex_aws_sts
              mogrify
              sweet_xml
              sizeable
              faviconic
              bonfire_api_graphql
              image
              evision
              ex_aws_s3
              activity_pub
              blurhash
            ];
          };
        in
        drv;

      bonfire_mailer =
        let
          version = "0.1.0";
          drv = buildMix {
            inherit version;
            name = "bonfire_mailer";
            appConfigPath = ./config;

            src = fetchFromGitHub {
              owner = "bonfire-networks";
              repo = "bonfire_mailer";
              rev = "4ee19a4a1acb98f8cb4c8c03d3cc721a4b185e28";
              hash = "sha256-kCSQ7AZLcXBagbvcETB+RZJn+yvoE/zZ+jKLUfKpmn0=";
            };

            beamDeps = [
              bonfire_common
              decent
              gettext
              jason
              swoosh
              phoenix_swoosh
              mua
              mail
              mjml
              gen_smtp
              faker_fork
              email_checker
              multipart
            ];
          };
        in
        drv;

      bonfire_me =
        let
          version = "0.1.0";
          drv = buildMix {
            inherit version;
            name = "bonfire_me";
            appConfigPath = ./config;

            src = fetchFromGitHub {
              owner = "bonfire-networks";
              repo = "bonfire_me";
              rev = "59211c8985097a950c40e0f5374e0f8ecf83ebed";
              hash = "sha256-x4WyZKqdMjXst1WEvQWLrKpwU5LdYhCh8+5efGhjsF8=";
            };

            beamDeps = [
              activity_pub
              bonfire_common
              bonfire_epics
              bonfire_mailer
              bonfire_data_activity_pub
              bonfire_data_identity
              bonfire_data_social
              bonfire_boundaries
              faker_fork
              telemetry
              telemetry_metrics
              telemetry_poller
              floki
              bonfire_api_graphql
              bonfire_files
              absinthe
            ];
          };
        in
        drv;

      bonfire_notify =
        let
          version = "0.1.0";
          drv = buildMix {
            inherit version;
            name = "bonfire_notify";
            appConfigPath = ./config;

            src = fetchFromGitHub {
              owner = "bonfire-networks";
              repo = "bonfire_notify";
              rev = "6d0fe439399d8c1b970d8044e503ed980d9bda3b";
              hash = "sha256-zepRoPOMyxWjD/pzLaa8BhpHJP9pmQbCliYfA5ASeOA=";
            };

            beamDeps = [
              bonfire_common
              bonfire_ui_common
              bonfire_data_identity
              bonfire_me
              ecto_sql
              faker_fork
              gettext
              jason
              postgrex
              recase
              telemetry_metrics
              telemetry_poller
              ex_nudge
            ];
          };
        in
        drv;

      bonfire_posts =
        let
          version = "0.1.0";
          drv = buildMix {
            inherit version;
            name = "bonfire_posts";
            appConfigPath = ./config;

            src = fetchFromGitHub {
              owner = "bonfire-networks";
              repo = "bonfire_posts";
              rev = "268952434c7acc55b8fabea2d189fdaf8359ef98";
              hash = "sha256-9ZgPyxTwMaY4vUSbjo4KIZme81vqhQphwfk3hZ/ZN1M=";
            };

            beamDeps = [
              bonfire_common
              bonfire_social
              bonfire_epics
              bonfire_ecto
              bonfire_data_social
              verbs
              faker_fork
              jason
              bonfire_me
              bonfire_api_graphql
              absinthe
            ];
          };
        in
        drv;

      bonfire_social =
        let
          version = "0.1.0";
          drv = buildMix {
            inherit version;
            name = "bonfire_social";
            appConfigPath = ./config;

            src = fetchFromGitHub {
              owner = "bonfire-networks";
              repo = "bonfire_social";
              rev = "3e69c22fe43e75b32556a9cf33ad7b86a35ca274";
              hash = "sha256-9mssjVfh7b96SqtEH6Bw22Ok/nkoqeVwl6eEZgYOiK4=";
            };

            beamDeps = [
              bonfire_common
              bonfire_epics
              bonfire_boundaries
              bonfire_ecto
              bonfire_data_social
              verbs
              paper_trail
              nimble_csv
              faker_fork
              jason
              uniq
              lazy_html
              typed_ecto_schema
              bonfire_me
              bonfire_api_graphql
              bonfire_tag
              bonfire_files
              absinthe
            ];
          };
        in
        drv;

      bonfire_social_graph =
        let
          version = "0.1.0";
          drv = buildMix {
            inherit version;
            name = "bonfire_social_graph";
            appConfigPath = ./config;

            src = fetchFromGitHub {
              owner = "bonfire-networks";
              repo = "bonfire_social_graph";
              rev = "a93432ddb163e0f687a31fc0ea6f7575ff41ef5a";
              hash = "sha256-f16VCELjF+5cuG7TeGX0Ev+i3FwhpIHJBslzzCDXQTs=";
            };

            beamDeps = [
              bonfire_common
              bonfire_social
              bonfire_epics
              bonfire_ecto
              bonfire_data_social
              verbs
              nimble_csv
              faker_fork
              jason
              boltx
              bonfire_me
              bonfire_api_graphql
              absinthe
            ];
          };
        in
        drv;

      bonfire_tag =
        let
          version = "0.1.0";
          drv = buildMix {
            inherit version;
            name = "bonfire_tag";
            appConfigPath = ./config;

            src = fetchFromGitHub {
              owner = "bonfire-networks";
              repo = "bonfire_tag";
              rev = "fbe09ace6cad298e751dbca815648d76dc84771a";
              hash = "sha256-7rSN0Bwgl1BpEDCXrfhuCOaux22SbX0/UmAYF+0BeHY=";
            };

            beamDeps = [
              bonfire_common
              bonfire_epics
              bonfire_ui_common
              linkify
              faker_fork
              jason
              telemetry_metrics
              telemetry_poller
              html_entities
              absinthe
              bonfire_api_graphql
            ];
          };
        in
        drv;

      bonfire_ui_boundaries =
        let
          version = "0.0.1";
          drv = buildMix {
            inherit version;
            name = "bonfire_ui_boundaries";
            appConfigPath = ./config;

            src = fetchFromGitHub {
              owner = "bonfire-networks";
              repo = "bonfire_ui_boundaries";
              rev = "296853fb5ff6df9f7d0c44500a64bb5cb12f5ffd";
              hash = "sha256-/Axn65EXIVSCAGXRbRIxdhUg3fT+gAjo5IWuekAq/3Y=";
            };

            beamDeps = [
              bonfire_common
              bonfire_boundaries
              bonfire_ui_common
              faker_fork
              jason
            ];
          };
        in
        drv;

      bonfire_ui_common =
        let
          version = "0.1.0";
          drv = buildMix {
            inherit version;
            name = "bonfire_ui_common";
            appConfigPath = ./config;

            src = fetchFromGitHub {
              owner = "bonfire-networks";
              repo = "bonfire_ui_common";
              rev = "bcebf6bcaf7dacc828d5e62f07c29d9006976743";
              hash = "sha256-+cspzw6kB92xEahchpGiKEECgfuzFCRSBjfquw7qgEU=";
            };

            beamDeps = [
              bonfire_common
              phoenix_gon
              bonfire_fail
              surf_context
              surf_live_attr
              iconify_ex
              plausible_proxy
              jason
              surface
              surface_form_helpers
              phoenix_live_view
              phoenix_live_dashboard
              phoenix_view
              phoenix_ecto
              remote_ip
              plug_cowboy
              cors_plug
              faker_fork
              makeup_elixir
              makeup_eex
              makeup_html
              makeup_js
              makeup_json
              makeup_diff
              makeup_sql
              makeup_graphql
              makeup_erlang
              solid
              live_select
              chameleon
              phoenix_live_favicon
              phoenix_seo
              plug_early_hints
              oban
              hammer
              ansi_to_html
              zest
            ];
          };
        in
        drv;

      bonfire_ui_me =
        let
          version = "0.1.0";
          drv = buildMix {
            inherit version;
            name = "bonfire_ui_me";
            appConfigPath = ./config;

            src = fetchFromGitHub {
              owner = "bonfire-networks";
              repo = "bonfire_ui_me";
              rev = "49e42ba490e717a4e4d294f08f0a75d6934911df";
              hash = "sha256-PaKLstjZrgJ2S7AfOv5kn9e7HVMljMG4jOvM8X5Pkvo=";
            };

            beamDeps = [
              bonfire_common
              bonfire_me
              bonfire_ui_common
              bonfire_files
              verbs
              faker_fork
              gettext
              jason
              recase
              telemetry_metrics
              telemetry_poller
              zstream
              floki
              surface
              phoenix_live_view
              phoenix
            ];
          };
        in
        drv;

      bonfire_ui_moderation =
        let
          version = "0.1.0";
          drv = buildMix {
            inherit version;
            name = "bonfire_ui_moderation";
            appConfigPath = ./config;

            src = fetchFromGitHub {
              owner = "bonfire-networks";
              repo = "bonfire_ui_moderation";
              rev = "ec31726a89240ec12c171ef8524e20e58da71679";
              hash = "sha256-2SjwHJX8BYdgvvH8TV/o+pu1HEqzz3XAv2rB0iEsiHo=";
            };

            beamDeps = [
              bonfire_common
              bonfire_social
              bonfire_ui_common
              verbs
              faker_fork
              gettext
              jason
              recase
              exdiff
              bonfire_tag
            ];
          };
        in
        drv;

      bonfire_ui_posts =
        let
          version = "0.1.0";
          drv = buildMix {
            inherit version;
            name = "bonfire_ui_posts";
            appConfigPath = ./config;

            src = fetchFromGitHub {
              owner = "bonfire-networks";
              repo = "bonfire_ui_posts";
              rev = "3f95a0b3c2a45bbf1c886708a401edf88fd3cb07";
              hash = "sha256-Rnu8SCSRw7MVm/atdgK/9r5jno0AED7lUvl3Z7xsrlY=";
            };

            beamDeps = [
              bonfire_common
              bonfire_posts
              bonfire_ui_common
              verbs
              faker_fork
              gettext
              jason
              recase
              exdiff
              bonfire_tag
            ];
          };
        in
        drv;

      bonfire_ui_reactions =
        let
          version = "0.1.0";
          drv = buildMix {
            inherit version;
            name = "bonfire_ui_reactions";
            appConfigPath = ./config;

            src = fetchFromGitHub {
              owner = "bonfire-networks";
              repo = "bonfire_ui_reactions";
              rev = "47be6b27ef9411d649bb03a4798a6395d7c93f07";
              hash = "sha256-zlRSiWLjHIqxiL+35Vd9ny6SMuL7qUTGnAoPXp8F1G8=";
            };

            beamDeps = [
              bonfire_common
              bonfire_social
              bonfire_ui_common
              verbs
              faker_fork
              gettext
              jason
              recase
              exdiff
              surface
              bonfire_tag
            ];
          };
        in
        drv;

      bonfire_ui_social =
        let
          version = "0.1.0";
          drv = buildMix {
            inherit version;
            name = "bonfire_ui_social";
            appConfigPath = ./config;

            src = fetchFromGitHub {
              owner = "bonfire-networks";
              repo = "bonfire_ui_social";
              rev = "0f938e8af2da41df2085c0ea36fabb0565dc341c";
              hash = "sha256-sGtohUye3EI2Qw+EeKZx0CJHc0sUDoW89nlqjXjcS/Y=";
            };

            beamDeps = [
              bonfire_common
              bonfire_social
              bonfire_ui_common
              verbs
              faker_fork
              gettext
              jason
              recase
              exdiff
              surface
              floki
              bonfire_ui_me
              bonfire_tag
            ];
          };
        in
        drv;

      bonfire_ui_social_graph =
        let
          version = "0.1.0";
          drv = buildMix {
            inherit version;
            name = "bonfire_ui_social_graph";
            appConfigPath = ./config;

            src = fetchFromGitHub {
              owner = "bonfire-networks";
              repo = "bonfire_ui_social_graph";
              rev = "52b4478aa6b49c244a7acc1d871ebe6f41e78df4";
              hash = "sha256-efXGRnqjzu+W19z3rergDYWeGJWc+Zn5B1xJOJd3WQs=";
            };

            beamDeps = [
              bonfire_common
              bonfire_social_graph
              verbs
              faker_fork
              gettext
              jason
              recase
              exdiff
              bonfire_tag
            ];
          };
        in
        drv;

      brex_result =
        let
          version = "0.4.0";
          drv = buildMix {
            inherit version;
            name = "brex_result";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "brex_result";
              sha256 = "c221aac71c48727ef55dc56cf845772a54e1db538564280c868eb0595e1e44f8";
            };
          };
        in
        drv;

      bumblebee =
        let
          version = "0.7.1";
          drv = buildMix {
            inherit version;
            name = "bumblebee";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "bumblebee";
              sha256 = "f26b3355700e3c7580014d41ce477d87d9fd71a60b76d5b64701dacb07830a58";
            };

            beamDeps = [
              axon
              jason
              nx
              nx_image
              nx_signal
              safetensors
              tokenizers
              unpickler
              unzip
            ];
          };
        in
        drv;

      cachex =
        let
          version = "4.1.1";
          drv = buildMix {
            inherit version;
            name = "cachex";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "cachex";
              sha256 = "d6b7449ff98d6bb92dda58bd4fc3189cae9f99e7042054d669596f56dc503cd8";
            };

            beamDeps = [
              eternal
              ex_hash_ring
              jumper
              sleeplocks
              unsafe
            ];
          };
        in
        drv;

      castore =
        let
          version = "1.0.20";
          drv = buildMix {
            inherit version;
            name = "castore";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "castore";
              sha256 = "940eafbfd8b14bee649f083bc11b3b54ec555b54c3e4ea8213351ff6fee39c10";
            };
          };
        in
        drv;

      cc_precompiler =
        let
          version = "0.1.11";
          drv = buildMix {
            inherit version;
            name = "cc_precompiler";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "cc_precompiler";
              sha256 = "3427232caf0835f94680e5bcf082408a70b48ad68a5f5c0b02a3bea9f3a075b9";
            };

            beamDeps = [
              elixir_make
            ];
          };
        in
        drv.override (workarounds.elixirMake { } drv);

      certifi =
        let
          version = "2.15.0";
          drv = buildRebar3 {
            inherit version;
            name = "certifi";

            src = fetchHex {
              inherit version;
              pkg = "certifi";
              sha256 = "b147ed22ce71d72eafdad94f055165c1c182f61a2ff49df28bcc71d1d5b94a60";
            };
          };
        in
        drv;

      chameleon =
        let
          version = "2.5.0";
          drv = buildMix {
            inherit version;
            name = "chameleon";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "chameleon";
              sha256 = "f3559827d8b4fe53a44e19e56ae94bedd36a355e0d33e18067b8abc37ec428db";
            };
          };
        in
        drv;

      chatterbox =
        let
          version = "0.16.0";
          drv = buildRebar3 {
            inherit version;
            name = "chatterbox";

            src = fetchHex {
              inherit version;
              pkg = "ts_chatterbox";
              sha256 = "34c145c702f3a8d22f49a189eb34579ef3db68f9a98a82d19b5cf6e390aad54f";
            };

            beamDeps = [
              hpack
            ];
          };
        in
        drv;

      cldr_utils =
        let
          version = "2.29.7";
          drv = buildMix {
            inherit version;
            name = "cldr_utils";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "cldr_utils";
              sha256 = "4bddcd597fee34e2d2829ae9ef62bcfef8d97ae5f6b75f0c6ee37a3db31aa73a";
            };

            beamDeps = [
              castore
              certifi
              decimal
            ];
          };
        in
        drv;

      color =
        let
          version = "0.13.0";
          drv = buildMix {
            inherit version;
            name = "color";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "color";
              sha256 = "de127946869931d418bac2d82dc29feae1a8f5f729f135922fbccf0059a58ab2";
            };

            beamDeps = [
              bandit
              plug
            ];
          };
        in
        drv;

      combine =
        let
          version = "0.10.0";
          drv = buildMix {
            inherit version;
            name = "combine";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "combine";
              sha256 = "1b1dbc1790073076580d0d1d64e42eae2366583e7aecd455d1215b0d16f2451b";
            };
          };
        in
        drv;

      comeonin =
        let
          version = "5.5.1";
          drv = buildMix {
            inherit version;
            name = "comeonin";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "comeonin";
              sha256 = "65aac8f19938145377cee73973f192c5645873dcf550a8a6b18187d17c13ccdb";
            };
          };
        in
        drv;

      complex =
        let
          version = "0.7.0";
          drv = buildMix {
            inherit version;
            name = "complex";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "complex";
              sha256 = "0ee39c0803129f546e7f3f640da8f021c9e659402bf59da6f7f2c4848f068f8d";
            };
          };
        in
        drv;

      cors_plug =
        let
          version = "3.0.3";
          drv = buildMix {
            inherit version;
            name = "cors_plug";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "cors_plug";
              sha256 = "3f2d759e8c272ed3835fab2ef11b46bddab8c1ab9528167bd463b6452edf830d";
            };

            beamDeps = [
              plug
            ];
          };
        in
        drv;

      cowboy =
        let
          version = "2.18.0";
          drv = buildRebar3 {
            inherit version;
            name = "cowboy";

            src = fetchHex {
              inherit version;
              pkg = "cowboy";
              sha256 = "62d0b26abcf455054972b0da242389c69d5982ce5914afb8c344517f667b9600";
            };

            beamDeps = [
              cowlib
              ranch
            ];
          };
        in
        drv;

      cowboy_telemetry =
        let
          version = "0.4.0";
          drv = buildRebar3 {
            inherit version;
            name = "cowboy_telemetry";

            src = fetchHex {
              inherit version;
              pkg = "cowboy_telemetry";
              sha256 = "7d98bac1ee4565d31b62d59f8823dfd8356a169e7fcbb83831b8a5397404c9de";
            };

            beamDeps = [
              cowboy
              telemetry
            ];
          };
        in
        drv;

      cowlib =
        let
          version = "2.19.0";
          drv = buildRebar3 {
            inherit version;
            name = "cowlib";

            src = fetchHex {
              inherit version;
              pkg = "cowlib";
              sha256 = "6dc66e3135b229193ea4dcb14294e79520c923d391315c9c962ef0b4bea72356";
            };
          };
        in
        drv;

      ctx =
        let
          version = "0.6.0";
          drv = buildRebar3 {
            inherit version;
            name = "ctx";

            src = fetchHex {
              inherit version;
              pkg = "ctx";
              sha256 = "a14ed2d1b67723dbebbe423b28d7615eb0bdcba6ff28f2d1f1b0a7e1d4aa5fc2";
            };
          };
        in
        drv;

      dataloader =
        let
          version = "2.0.2";
          drv = buildMix {
            inherit version;
            name = "dataloader";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "dataloader";
              sha256 = "4c6cabc0b55e96e7de74d14bf37f4a5786f0ab69aa06764a1f39dda40079b098";
            };

            beamDeps = [
              ecto
              opentelemetry_process_propagator
              telemetry
            ];
          };
        in
        drv;

      db_connection =
        let
          version = "2.10.2";
          drv = buildMix {
            inherit version;
            name = "db_connection";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "db_connection";
              sha256 = "510b14482330f1af6490a2fa0efd8d4f1435d1529b165647df22ac0f2df0fa93";
            };

            beamDeps = [
              telemetry
            ];
          };
        in
        drv;

      decent =
        let
          version = "0.2.0";
          drv = buildMix {
            inherit version;
            name = "decent";
            appConfigPath = ./config;

            src = fetchFromGitHub {
              owner = "bonfire-networks";
              repo = "decent";
              rev = "de83e219c527cde6ad2518d6ed024a8fd841f40b";
              hash = "sha256-Qkrq07qrr+69/REGRVhQikr3oqOOOlUrTMKe0AIK5eE=";
            };

            beamDeps = [
              rustler_precompiled
            ];
          };
        in
        drv.override (workarounds.rustlerPrecompiled { } drv);

      decimal =
        let
          version = "3.1.1";
          drv = buildMix {
            inherit version;
            name = "decimal";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "decimal";
              sha256 = "c5f25f2ced74a0587d03e6023f595db8e924c9d3922c8c8ffd9edfc4498cf1f6";
            };
          };
        in
        drv;

      decorator =
        let
          version = "1.4.0";
          drv = buildMix {
            inherit version;
            name = "decorator";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "decorator";
              sha256 = "0a07cedd9083da875c7418dea95b78361197cf2bf3211d743f6f7ce39656597f";
            };
          };
        in
        drv;

      deep_merge =
        let
          version = "1.0.2";
          drv = buildMix {
            inherit version;
            name = "deep_merge";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "deep_merge";
              sha256 = "737a53cdc9758fedbb608bdc213969e65729466c4ef3cd8e8726d0335dff116c";
            };
          };
        in
        drv;

      deps_nix =
        let
          version = "3.1.0";
          drv = buildMix {
            inherit version;
            name = "deps_nix";
            appConfigPath = ./config;

            src = fetchFromGitHub {
              owner = "code-supply";
              repo = "deps_nix";
              rev = "102a5e657cc653fbf5b578555461c2c17e33a1fb";
              hash = "sha256-cNmn8iKinLjPvetwFEOtSI7ZtNWY7DVRcwvzlBxaWiY=";
            };

            beamDeps = [
              ex_nar
              mint
            ];
          };
        in
        drv;

      digital_token =
        let
          version = "1.0.0";
          drv = buildMix {
            inherit version;
            name = "digital_token";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "digital_token";
              sha256 = "8ed6f5a8c2fa7b07147b9963db506a1b4c7475d9afca6492136535b064c9e9e6";
            };

            beamDeps = [
              cldr_utils
              jason
            ];
          };
        in
        drv;

      dog_sketch =
        let
          version = "0.1.3";
          drv = buildMix {
            inherit version;
            name = "dog_sketch";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "dog_sketch";
              sha256 = "be6d172a3d3809a0acbc85421a5d25a794841560b6f930540c345342c591d0df";
            };
          };
        in
        drv;

      earmark_parser =
        let
          version = "1.4.46";
          drv = buildMix {
            inherit version;
            name = "earmark_parser";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "earmark_parser";
              sha256 = "9c44636e8a1c68c62f526b2dcd85d941dbbcee7ab82cf64ba06ce28bef8e89f5";
            };
          };
        in
        drv;

      ecto =
        let
          version = "3.14.1";
          drv = buildMix {
            inherit version;
            name = "ecto";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "ecto";
              sha256 = "24b991956796700f467d0a3ef3d303138a3ef9ddddf8b98f43758ee067b20a30";
            };

            beamDeps = [
              decimal
              jason
              telemetry
            ];
          };
        in
        drv;

      ecto_dev_logger =
        let
          version = "0.15.0";
          drv = buildMix {
            inherit version;
            name = "ecto_dev_logger";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "ecto_dev_logger";
              sha256 = "b2c807d7d599a4fcf288139851c09262333b193bdb41f8d65f515853d117e88a";
            };

            beamDeps = [
              ecto
              geo
              jason
              postgrex
            ];
          };
        in
        drv;

      ecto_materialized_path =
        let
          version = "0.3.0";
          drv = buildMix {
            inherit version;
            name = "ecto_materialized_path";
            appConfigPath = ./config;

            src = fetchFromGitHub {
              owner = "bonfire-networks";
              repo = "ecto_materialized_path";
              rev = "3b3d2758650c9b857985311a90c31fa91cc3702f";
              hash = "sha256-pbvvAcSas+EReP9x815hn01OlGDNAeMO/Db2mvQc+eM=";
            };

            beamDeps = [
              ecto
              needle_uid
              untangle
            ];
          };
        in
        drv;

      ecto_psql_extras =
        let
          version = "0.8.8";
          drv = buildMix {
            inherit version;
            name = "ecto_psql_extras";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "ecto_psql_extras";
              sha256 = "04c63d92b141723ad6fed2e60a4b461ca00b3594d16df47bbc48f1f4534f2c49";
            };

            beamDeps = [
              ecto_sql
              postgrex
              table_rex
            ];
          };
        in
        drv;

      ecto_ranked =
        let
          version = "0.6.1";
          drv = buildMix {
            inherit version;
            name = "ecto_ranked";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "ecto_ranked";
              sha256 = "39504f290103950448926637660cb91f02b936e75bb6ae307cbcf80bf487962d";
            };

            beamDeps = [
              ecto_sql
            ];
          };
        in
        drv;

      ecto_shorts =
        let
          version = "1.1.1";
          drv = buildMix {
            inherit version;
            name = "ecto_shorts";
            appConfigPath = ./config;

            src = fetchFromGitHub {
              owner = "bonfire-networks";
              repo = "ecto_shorts";
              rev = "5aca05867914d44b225bc1b03c7a794a337ce210";
              hash = "sha256-lPivoGozxDfkMpokCFTBtWQsM98tK8GGyn8DqiX0tnk=";
            };

            beamDeps = [
              ecto_sql
            ];
          };
        in
        drv;

      ecto_sparkles =
        let
          version = "0.4.0";
          drv = buildMix {
            inherit version;
            name = "ecto_sparkles";
            appConfigPath = ./config;

            src = fetchFromGitHub {
              owner = "bonfire-networks";
              repo = "ecto_sparkles";
              rev = "02e90d74978582774d92b32673813d2baa6eb498";
              hash = "sha256-8bLJI/OsRKGvhzcfaawbE1QH4GTIkq+1dRAqumKv714=";
            };

            beamDeps = [
              ecto
              ecto_sql
              ecto_dev_logger
              recase
              untangle
              process_tree
              plug_crypto
              json_serde
              html_sanitize_ex
            ];
          };
        in
        drv;

      ecto_sql =
        let
          version = "3.14.0";
          drv = buildMix {
            inherit version;
            name = "ecto_sql";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "ecto_sql";
              sha256 = "f4d8d36faf294c9417b5a37ec7ac8217ee2abdef5fcf197ba690f361548d3949";
            };

            beamDeps = [
              db_connection
              decimal
              ecto
              postgrex
              telemetry
            ];
          };
        in
        drv;

      ecto_vista =
        let
          version = "0.2.0";
          drv = buildMix {
            inherit version;
            name = "ecto_vista";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "ecto_vista";
              sha256 = "a1beb25e78e418b6437ed1d2e3f299b1822390926e58a02954be9c4718377a12";
            };

            beamDeps = [
              ecto
              ecto_sql
              postgrex
            ];
          };
        in
        drv;

      elixir_make =
        let
          version = "0.10.0";
          drv = buildMix {
            inherit version;
            name = "elixir_make";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "elixir_make";
              sha256 = "dc1f09fb7fa68866b886abd5f0f3c83553b1a19a52359a899e92af1bb3b31982";
            };
          };
        in
        drv;

      email_checker =
        let
          version = "0.2.4";
          drv = buildMix {
            inherit version;
            name = "email_checker";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "email_checker";
              sha256 = "e4ac0e5eb035dce9c8df08ebffdb525a5d82e61dde37390ac2469222f723e50a";
            };
          };
        in
        drv;

      ember =
        let
          version = "0.0.1";
          drv = buildMix {
            inherit version;
            name = "ember";
            appConfigPath = ./config;

            src = fetchFromGitHub {
              owner = "bonfire-networks";
              repo = "ember";
              rev = "226288ccb2addde9e1e2753081129043f4c8c57e";
              hash = "sha256-O9tb/WasaedE6+rz7hvuJ4/i2M5IohIVi8QG8F+obTM=";
            };

            beamDeps = [
              bonfire_common
              bonfire_ui_common
              activity_pub
              bonfire_mailer
              bonfire_epics
              bonfire_ecto
              bonfire_data_assort
              bonfire_boundaries
              bonfire_ui_boundaries
              bonfire_federate_activitypub
              bonfire_data_access_control
              bonfire_data_activity_pub
              bonfire_data_identity
              bonfire_data_social
              bonfire_data_edges
              bonfire_editor_milkdown
              bonfire_articles
              bonfire_me
              bonfire_ui_me
              bonfire_social
              bonfire_social_graph
              bonfire_posts
              bonfire_ui_social
              bonfire_ui_social_graph
              bonfire_ui_posts
              bonfire_ui_moderation
              bonfire_ui_reactions
              bonfire_tag
              bonfire_classify
              bonfire_notify
              ecto_sparkles
              needle
              needle_uid
              needle_ulid
              ex_ulid
              untangle
              entrepot
              entrepot_ecto
              nodeinfo
              paginator
              voodoo
              paper_trail
              arrows
              ex_cldr
              surface
              phoenix
              phoenix_live_view
              phoenix_view
              plug_crypto
              plug_cowboy
              cowboy
              gettext
              bandit
              orion
              ecto
              ecto_sql
              postgrex
              ecto_psql_extras
              db_connection
              ex_aws_s3
              ex_marcel
              req
              finch
              httpoison
              jason
              poison
              timex
              solid
              mime
              oban
              sourceror
              owl
              mogrify
              cachex
              sizeable
              geo
              recase
              emote
              uniq
              rustler_precompiled
              decimal
              floki
              faker_fork
              text
              text_corpus_udhr
              hackney
              idna
              opentelemetry_process_propagator
              opentelemetry_exporter
              opentelemetry_semantic_conventions
              telemetry_metrics
              telemetry
              telemetry_poller
              sentry
              oban_web
              absinthe
              bonfire_api_graphql
              absinthe_client
            ];
          };
        in
        drv.override (workarounds.rustlerPrecompiled { } drv);

      emote =
        let
          version = "0.1.1";
          drv = buildMix {
            inherit version;
            name = "emote";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "emote";
              sha256 = "d11219eb76966b0f38adb5ad12eef8dc6c7bb3929cfcdcd4ce9deb2bf784a0ce";
            };

            beamDeps = [
              phoenix_html
            ];
          };
        in
        drv;

      entrepot =
        let
          version = "0.11.0";
          drv = buildMix {
            inherit version;
            name = "entrepot";
            appConfigPath = ./config;

            src = fetchFromGitHub {
              owner = "bonfire-networks";
              repo = "entrepot";
              rev = "c75704d8b4b76dbd2277b52822fa77ec8dc207aa";
              hash = "sha256-sFLvmdAThsdTpVs+ThhwxR7zuZgMbye+pQSE2Y+80do=";
            };

            beamDeps = [
              ex_aws
              ex_aws_s3
            ];
          };
        in
        drv;

      entrepot_ecto =
        let
          version = "0.11.0";
          drv = buildMix {
            inherit version;
            name = "entrepot_ecto";
            appConfigPath = ./config;

            src = fetchFromGitHub {
              owner = "bonfire-networks";
              repo = "entrepot_ecto";
              rev = "5ea4af9af6b648e2cf58a2ceb2eb8e9c36c2b226";
              hash = "sha256-yOdb7S7FwOaslvxR4b2naxlOnYGMx0CI7jf5DmPHaUw=";
            };

            beamDeps = [
              entrepot
              ecto
            ];
          };
        in
        drv;

      eternal =
        let
          version = "1.2.2";
          drv = buildMix {
            inherit version;
            name = "eternal";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "eternal";
              sha256 = "2c9fe32b9c3726703ba5e1d43a1d255a4f3f2d8f8f9bc19f094c7cb1a7a9e782";
            };
          };
        in
        drv;

      evision =
        let
          version = "0.2.17";
          drv = buildMix {
            inherit version;
            name = "evision";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "evision";
              sha256 = "565bc8700d23cd2429444387a1cf0e53fe7a85892e9276ce62a9cef23350c11f";
            };

            beamDeps = [
              castore
              elixir_make
              nx
            ];
          };
        in
        drv.override (workarounds.elixirMake { } drv);

      ex2ms =
        let
          version = "1.7.0";
          drv = buildMix {
            inherit version;
            name = "ex2ms";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "ex2ms";
              sha256 = "2589eee51f81f1b1caa6d08c990b1ad409215fe6f64c73f73c67d36ed10be827";
            };
          };
        in
        drv;

      ex_aws =
        let
          version = "2.7.0";
          drv = buildMix {
            inherit version;
            name = "ex_aws";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "ex_aws";
              sha256 = "bfe9d744d4fd4c1f40314ee7fab504d5547d1f01cd377fff1568cbe630b06d65";
            };

            beamDeps = [
              hackney
              jason
              mime
              req
              sweet_xml
              telemetry
            ];
          };
        in
        drv;

      ex_aws_s3 =
        let
          version = "2.5.9";
          drv = buildMix {
            inherit version;
            name = "ex_aws_s3";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "ex_aws_s3";
              sha256 = "a480d2bb2da64610014021629800e1e9457ca5e4a62f6775bffd963360c2bf90";
            };

            beamDeps = [
              ex_aws
              sweet_xml
            ];
          };
        in
        drv;

      ex_aws_sts =
        let
          version = "2.3.0";
          drv = buildMix {
            inherit version;
            name = "ex_aws_sts";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "ex_aws_sts";
              sha256 = "f14e4c7da3454514bf253b331e9422d25825485c211896ab3b81d2a4bdbf62f5";
            };

            beamDeps = [
              ex_aws
            ];
          };
        in
        drv;

      ex_cldr =
        let
          version = "2.47.5";
          drv = buildMix {
            inherit version;
            name = "ex_cldr";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "ex_cldr";
              sha256 = "8637e14a966fa68381e9765afd03d8fc703d6f3bc5c7c3e5fe59354566777595";
            };

            beamDeps = [
              cldr_utils
              decimal
              gettext
              jason
              nimble_parsec
            ];
          };
        in
        drv;

      ex_cldr_calendars =
        let
          version = "2.4.4";
          drv = buildMix {
            inherit version;
            name = "ex_cldr_calendars";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "ex_cldr_calendars";
              sha256 = "40a15cec56aa9c7752b4c9248cc321880f22ef2f3401b69c984c4da242b19a68";
            };

            beamDeps = [
              digital_token
              ex_cldr_lists
              ex_cldr_numbers
              ex_cldr_units
              ex_doc
              jason
            ];
          };
        in
        drv;

      ex_cldr_currencies =
        let
          version = "2.17.2";
          drv = buildMix {
            inherit version;
            name = "ex_cldr_currencies";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "ex_cldr_currencies";
              sha256 = "797095c106a2fe6632981531e29cfb1d2f8ee7de626f4d6243f974d6f74a0112";
            };

            beamDeps = [
              ex_cldr
              jason
            ];
          };
        in
        drv;

      ex_cldr_dates_times =
        let
          version = "2.25.6";
          drv = buildMix {
            inherit version;
            name = "ex_cldr_dates_times";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "ex_cldr_dates_times";
              sha256 = "926ff5662b849f86088832ee66b61a96aab0fa5a54d5e14240e08ad3030663e2";
            };

            beamDeps = [
              ex_cldr_calendars
              ex_cldr_units
              jason
            ];
          };
        in
        drv;

      ex_cldr_languages =
        let
          version = "0.3.3";
          drv = buildMix {
            inherit version;
            name = "ex_cldr_languages";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "ex_cldr_languages";
              sha256 = "22fb1fef72b7b4b4872d243b34e7b83734247a78ad87377986bf719089cc447a";
            };

            beamDeps = [
              ex_cldr
              jason
            ];
          };
        in
        drv;

      ex_cldr_lists =
        let
          version = "2.12.2";
          drv = buildMix {
            inherit version;
            name = "ex_cldr_lists";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "ex_cldr_lists";
              sha256 = "16e0b6dc63091c71a0c9a2c50e13db64798f261c3e121d7e3fb7d354872180e8";
            };

            beamDeps = [
              ex_cldr_numbers
              ex_doc
              jason
            ];
          };
        in
        drv;

      ex_cldr_locale_display =
        let
          version = "1.7.3";
          drv = buildMix {
            inherit version;
            name = "ex_cldr_locale_display";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "ex_cldr_locale_display";
              sha256 = "9420c6154524aff5c5ad798048649a73632dca978ab89fc8a865234aa184b212";
            };

            beamDeps = [
              ex_cldr
              ex_cldr_currencies
              ex_cldr_territories
              jason
            ];
          };
        in
        drv;

      ex_cldr_numbers =
        let
          version = "2.38.3";
          drv = buildMix {
            inherit version;
            name = "ex_cldr_numbers";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "ex_cldr_numbers";
              sha256 = "3a0d87ef2747c66d78ae8967023d415d3d76aa310981047ad601e3287e8fe73c";
            };

            beamDeps = [
              decimal
              digital_token
              ex_cldr
              ex_cldr_currencies
              jason
            ];
          };
        in
        drv;

      ex_cldr_plugs =
        let
          version = "1.4.0";
          drv = buildMix {
            inherit version;
            name = "ex_cldr_plugs";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "ex_cldr_plugs";
              sha256 = "0859ccd533bddd00a36008ea970ba2d6440c8f01b1d73b115f445015046277bc";
            };

            beamDeps = [
              ex_cldr
              gettext
              jason
              plug
            ];
          };
        in
        drv;

      ex_cldr_territories =
        let
          version = "2.12.0";
          drv = buildMix {
            inherit version;
            name = "ex_cldr_territories";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "ex_cldr_territories";
              sha256 = "d12bdd3dcc1debaed3268deed6a0d8f53409f540e6a3b1410ede6cf3a6a1f768";
            };

            beamDeps = [
              ex_cldr
              jason
            ];
          };
        in
        drv;

      ex_cldr_trans =
        let
          version = "1.1.3";
          drv = buildMix {
            inherit version;
            name = "ex_cldr_trans";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "ex_cldr_trans";
              sha256 = "9929885784052f17dc8fe214de9e8169c1ccf6efef887660ed57a8a5a3c0380e";
            };

            beamDeps = [
              ecto
              ecto_sql
              ex_cldr
              jason
              postgrex
            ];
          };
        in
        drv;

      ex_cldr_units =
        let
          version = "3.20.5";
          drv = buildMix {
            inherit version;
            name = "ex_cldr_units";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "ex_cldr_units";
              sha256 = "51e49f21d2c51127de7358367cc4fbc95eff04593b93ab07b20f12a076db6995";
            };

            beamDeps = [
              decimal
              digital_token
              ex_cldr_lists
              ex_cldr_numbers
              ex_doc
              jason
            ];
          };
        in
        drv;

      ex_confusables =
        let
          version = "0.1.1";
          drv = buildMix {
            inherit version;
            name = "ex_confusables";
            appConfigPath = ./config;

            src = fetchFromGitHub {
              owner = "bonfire-networks";
              repo = "ex_confusables";
              rev = "72826ede5b66ca0a1d1cdeb0c55085061a928ccb";
              hash = "sha256-K57eAhRSwH/FNWNusikrGwGm3DZpdPoCC2d71xzap8g=";
            };
          };
        in
        drv;

      ex_doc =
        let
          version = "0.40.3";
          drv = buildMix {
            inherit version;
            name = "ex_doc";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "ex_doc";
              sha256 = "2756e357742fecd9749b489b85d67c9ce99c465f2e75728d9e6dc8d704b973de";
            };

            beamDeps = [
              earmark_parser
              makeup_elixir
              makeup_erlang
              makeup_html
            ];
          };
        in
        drv;

      ex_hash_ring =
        let
          version = "6.0.4";
          drv = buildMix {
            inherit version;
            name = "ex_hash_ring";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "ex_hash_ring";
              sha256 = "89adabf31f7d3dfaa36802ce598ce918e9b5b33bae8909ac1a4d052e1e567d18";
            };
          };
        in
        drv;

      ex_marcel =
        let
          version = "0.2.0";
          drv = buildMix {
            inherit version;
            name = "ex_marcel";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "ex_marcel";
              sha256 = "fecf90bfe1cb4097d58ac7d444249afc9e8a314413f82cfb29a8a758ec65fcd5";
            };
          };
        in
        drv;

      ex_nar =
        let
          version = "0.3.0";
          drv = buildMix {
            inherit version;
            name = "ex_nar";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "ex_nar";
              sha256 = "cbb42d047764feac6c411efddcadc31866e9a998dd6e2bc1eb428cec1c49fdcd";
            };
          };
        in
        drv;

      ex_nudge =
        let
          version = "1.0.2";
          drv = buildMix {
            inherit version;
            name = "ex_nudge";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "ex_nudge";
              sha256 = "9e8fa9ab73926b8bb20672123940509c207bc1b09d2c3c2cf63027355a99e72b";
            };

            beamDeps = [
              httpoison
              jason
              jose
              telemetry
            ];
          };
        in
        drv;

      ex_ulid =
        let
          version = "0.1.0";
          drv = buildMix {
            inherit version;
            name = "ex_ulid";
            appConfigPath = ./config;

            src = fetchFromGitHub {
              owner = "bonfire-networks";
              repo = "ex_ulid";
              rev = "b07e0410b9d683385de081cfd5af0e3225b270f9";
              hash = "sha256-9G6o63auGDcrKGFRc0DLROLbBu3CiwKPlJ7Pt7vF8Hg=";
            };
          };
        in
        drv;

      exdiff =
        let
          version = "0.1.5";
          drv = buildMix {
            inherit version;
            name = "exdiff";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "exdiff";
              sha256 = "b1ccef642edc28ed3acf1b08c8dbc6e42852d18dfe51b453529588e53c733eba";
            };
          };
        in
        drv;

      exkismet =
        let
          version = "0.0.3";
          drv = buildMix {
            inherit version;
            name = "exkismet";
            appConfigPath = ./config;

            src = fetchFromGitHub {
              owner = "tcitworld";
              repo = "exkismet";
              rev = "68830454608d315f69d5fe1061ac1bf31c1a856e";
              hash = "sha256-mwLRQjAZoZSRLIQ7Xzp5SgSXu4JRXmgtgUcN+EteSsU=";
            };

            beamDeps = [
              httpoison
            ];
          };
        in
        drv;

      exla =
        let
          version = "0.13.0";
          drv = buildMix {
            inherit version;
            name = "exla";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "exla";
              sha256 = "781ec0231c4bbce87c1dc84cab4ae63ad763f03b2115e5d9b5481a97fbbe3ce5";
            };

            beamDeps = [
              elixir_make
              fine
              nimble_pool
              nx
              telemetry
              xla
            ];
          };
        in
        drv.override (workarounds.elixirMake { } drv);

      expo =
        let
          version = "1.1.1";
          drv = buildMix {
            inherit version;
            name = "expo";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "expo";
              sha256 = "5fb308b9cb359ae200b7e23d37c76978673aa1b06e2b3075d814ce12c5811640";
            };
          };
        in
        drv;

      exto =
        let
          version = "0.4.0";
          drv = buildMix {
            inherit version;
            name = "exto";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "exto";
              sha256 = "447afd96c2190c861db9f6201dfb733175473347a23c0c9d3169e17686ec7fd6";
            };

            beamDeps = [
              accessible
              ecto
            ];
          };
        in
        drv;

      faker_fork =
        let
          version = "0.19.1";
          drv = buildMix {
            inherit version;
            name = "faker_fork";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "faker_fork";
              sha256 = "f71a7e417216aa35917dd26790ba93fe2f1ce8440217fad8c233c922166e77bc";
            };
          };
        in
        drv;

      faviconic =
        let
          version = "0.3.0";
          drv = buildMix {
            inherit version;
            name = "faviconic";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "faviconic";
              sha256 = "8ad360f59111744f11572a82c7d12b5c6ecff2a7c0661b75a1d50c2dc8c0269c";
            };

            beamDeps = [
              floki
              process_tree
              req
              untangle
            ];
          };
        in
        drv;

      file_info =
        let
          version = "0.0.4";
          drv = buildMix {
            inherit version;
            name = "file_info";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "file_info";
              sha256 = "50e7ad01c2c8b9339010675fe4dc4a113b8d6ca7eddce24d1d74fd0e762781a5";
            };

            beamDeps = [
              mimetype_parser
            ];
          };
        in
        drv;

      file_system =
        let
          version = "1.1.1";
          drv = buildMix {
            inherit version;
            name = "file_system";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "file_system";
              sha256 = "7a15ff97dfe526aeefb090a7a9d3d03aa907e100e262a0f8f7746b78f8f87a5d";
            };
          };
        in
        drv;

      finch =
        let
          version = "0.23.0";
          drv = buildMix {
            inherit version;
            name = "finch";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "finch";
              sha256 = "80e58d3f936f57e3fdf404f83a3642897ae6d9fb642934e46da4d8fe761b99d5";
            };

            beamDeps = [
              mime
              mint
              nimble_options
              nimble_pool
              telemetry
            ];
          };
        in
        drv;

      fine =
        let
          version = "0.1.6";
          drv = buildMix {
            inherit version;
            name = "fine";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "fine";
              sha256 = "5638eb4495488e885ebec167fa57973e5c35e1a50c344eb7666c90ec1c4e3b12";
            };
          };
        in
        drv;

      floki =
        let
          version = "0.38.4";
          drv = buildMix {
            inherit version;
            name = "floki";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "floki";
              sha256 = "bdb34645eee8e79845c7edaca2d4099a52804ee4d4a3ecc683a69451f0244973";
            };
          };
        in
        drv;

      flow =
        let
          version = "1.2.4";
          drv = buildMix {
            inherit version;
            name = "flow";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "flow";
              sha256 = "874adde96368e71870f3510b91e35bc31652291858c86c0e75359cbdd35eb211";
            };

            beamDeps = [
              gen_stage
            ];
          };
        in
        drv;

      gen_smtp =
        let
          version = "1.3.0";
          drv = buildRebar3 {
            inherit version;
            name = "gen_smtp";

            src = fetchHex {
              inherit version;
              pkg = "gen_smtp";
              sha256 = "0b73fbf069864ecbce02fe653b16d3f35fd889d0fdd4e14527675565c39d84e6";
            };

            beamDeps = [
              ranch
            ];
          };
        in
        drv;

      gen_stage =
        let
          version = "1.3.2";
          drv = buildMix {
            inherit version;
            name = "gen_stage";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "gen_stage";
              sha256 = "0ffae547fa777b3ed889a6b9e1e64566217413d018cabd825f786e843ffe63e7";
            };
          };
        in
        drv;

      geo =
        let
          version = "4.1.0";
          drv = buildMix {
            inherit version;
            name = "geo";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "geo";
              sha256 = "19edb2b3398ca9f701b573b1fb11bc90951ebd64f18b06bd1bf35abe509a2934";
            };

            beamDeps = [
              jason
            ];
          };
        in
        drv;

      gettext =
        let
          version = "1.0.2";
          drv = buildMix {
            inherit version;
            name = "gettext";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "gettext";
              sha256 = "eab805501886802071ad290714515c8c4a17196ea76e5afc9d06ca85fb1bfeb3";
            };

            beamDeps = [
              expo
            ];
          };
        in
        drv;

      git_diff =
        let
          version = "0.6.4";
          drv = buildMix {
            inherit version;
            name = "git_diff";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "git_diff";
              sha256 = "9e05563c136c91e960a306fd296156b2e8d74e294ae60961e69a36e118023a5f";
            };
          };
        in
        drv;

      glob_ex =
        let
          version = "0.1.12";
          drv = buildMix {
            inherit version;
            name = "glob_ex";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "glob_ex";
              sha256 = "2e2fac83f113514434c7eaf267b4c38af2f91766f1cab2c5db7053b7fc1ee0bb";
            };
          };
        in
        drv;

      gproc =
        let
          version = "1.2.0";
          drv = buildRebar3 {
            inherit version;
            name = "gproc";

            src = fetchHex {
              inherit version;
              pkg = "gproc";
              sha256 = "70c6f8c91fa5974296cd87974949d8eab953230414f31c4a623ff75131e0827a";
            };
          };
        in
        drv;

      grpcbox =
        let
          version = "0.18.0";
          drv = buildRebar3 {
            inherit version;
            name = "grpcbox";

            src = fetchHex {
              inherit version;
              pkg = "grpcbox";
              sha256 = "5ec9f8fe664ab51201b32c117a61511a1f9d6316771e3891ba8a88d289a732ab";
            };

            beamDeps = [
              acceptor_pool
              chatterbox
              ctx
              gproc
            ];
          };
        in
        drv;

      hackney =
        let
          version = "1.25.0";
          drv = buildRebar3 {
            inherit version;
            name = "hackney";

            src = fetchHex {
              inherit version;
              pkg = "hackney";
              sha256 = "7209bfd75fd1f42467211ff8f59ea74d6f2a9e81cbcee95a56711ee79fd6b1d4";
            };

            beamDeps = [
              certifi
              idna
              metrics
              mimerl
              parse_trans
              ssl_verify_fun
              unicode_util_compat
            ];
          };
        in
        drv;

      hammer =
        let
          version = "7.4.0";
          drv = buildMix {
            inherit version;
            name = "hammer";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "hammer";
              sha256 = "ae50e0cadd17c68e2379eb8bf06b63bc882a2f9bd6350f8a2c2727c56d082b3d";
            };
          };
        in
        drv;

      hpack =
        let
          version = "0.3.0";
          drv = buildRebar3 {
            inherit version;
            name = "hpack";

            src = fetchHex {
              inherit version;
              pkg = "hpack_erl";
              sha256 = "d6137d7079169d8c485c6962dfe261af5b9ef60fbc557344511c1e65e3d95fb0";
            };
          };
        in
        drv;

      hpax =
        let
          version = "1.0.4";
          drv = buildMix {
            inherit version;
            name = "hpax";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "hpax";
              sha256 = "afc7cb142ebcc2d01ce7816190b98ce5dd49e799111b24249f3443d730f377ca";
            };
          };
        in
        drv;

      html_entities =
        let
          version = "0.5.2";
          drv = buildMix {
            inherit version;
            name = "html_entities";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "html_entities";
              sha256 = "c53ba390403485615623b9531e97696f076ed415e8d8058b1dbaa28181f4fdcc";
            };
          };
        in
        drv;

      html_sanitize_ex =
        let
          version = "1.5.2";
          drv = buildMix {
            inherit version;
            name = "html_sanitize_ex";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "html_sanitize_ex";
              sha256 = "807dc922a7ce3c388dd888e22550e25600e10a4fcb4433c291240ea17b18d1ad";
            };

            beamDeps = [
              mochiweb
            ];
          };
        in
        drv;

      http_signatures =
        let
          version = "0.1.1";
          drv = buildMix {
            inherit version;
            name = "http_signatures";
            appConfigPath = ./config;

            src = fetchFromGitHub {
              owner = "bonfire-networks";
              repo = "http_signatures";
              rev = "7b1b0ed2df1a9c6cc75ca03a07e91e73fb6c1e3e";
              hash = "sha256-SABAso6I3SWI9RGnPcsFaJ3iI3r9r7IycGpO1o5GU+4=";
            };

            beamDeps = [
              untangle
              http_structured_field
            ];
          };
        in
        drv;

      http_structured_field =
        let
          version = "0.1.4";
          drv = buildMix {
            inherit version;
            name = "http_structured_field";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "http_structured_field";
              sha256 = "fa5f58496bdbf3f7df239d1d24074d1709403cf977bfffd2286e8af5ca20e2d0";
            };

            beamDeps = [
              nimble_parsec
            ];
          };
        in
        drv;

      httpoison =
        let
          version = "2.3.0";
          drv = buildMix {
            inherit version;
            name = "httpoison";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "httpoison";
              sha256 = "d388ee70be56d31a901e333dbcdab3682d356f651f93cf492ba9f06056436a2c";
            };

            beamDeps = [
              hackney
            ];
          };
        in
        drv;

      iconify_ex =
        let
          version = "0.7.2";
          drv = buildMix {
            inherit version;
            name = "iconify_ex";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "iconify_ex";
              sha256 = "5efa322d905d27c988d7d6ba24af63862045e856e09b134c4ba083c5e235e552";
            };

            beamDeps = [
              arrows
              emote
              floki
              jason
              phoenix_live_favicon
              phoenix_live_view
              recase
              surface
              untangle
            ];
          };
        in
        drv;

      idna =
        let
          version = "7.1.0";
          drv = buildRebar3 {
            inherit version;
            name = "idna";

            src = fetchHex {
              inherit version;
              pkg = "idna";
              sha256 = "6ae959a025bf36df61a8cab8508d9654891b5426a84c44d82deaffd6ddf8c71f";
            };
          };
        in
        drv;

      igniter =
        let
          version = "0.7.9";
          drv = buildMix {
            inherit version;
            name = "igniter";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "igniter";
              sha256 = "123513d09f3af149db851aad8492b5b49f861d2c466a72031b2a0cbd9f45526f";
            };

            beamDeps = [
              glob_ex
              jason
              owl
              req
              rewrite
              sourceror
              spitfire
            ];
          };
        in
        drv;

      image =
        let
          version = "0.72.0";
          drv = buildMix {
            inherit version;
            name = "image";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "image";
              sha256 = "d55a6c3c90fe76e96265b655d85d6f2fafc439f66c6e792a4925f2d84378f3b0";
            };

            beamDeps = [
              color
              evision
              exla
              nx
              nx_image
              phoenix_html
              plug
              req
              sweet_xml
              vix
            ];
          };
        in
        drv;

      jason =
        let
          version = "1.4.5";
          drv = buildMix {
            inherit version;
            name = "jason";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "jason";
              sha256 = "b0c823996102bcd0239b3c2444eb00409b72f6a140c1950bc8b457d836b30684";
            };

            beamDeps = [
              decimal
            ];
          };
        in
        drv;

      jcs =
        let
          version = "0.2.0";
          drv = buildMix {
            inherit version;
            name = "jcs";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "jcs";
              sha256 = "f52e86571f56fab695682bf0ab7fd697768acb20de16b30809e9654d1ec1c9dd";
            };

            beamDeps = [
              jason
            ];
          };
        in
        drv;

      jose =
        let
          version = "1.11.12";
          drv = buildMix {
            inherit version;
            name = "jose";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "jose";
              sha256 = "31e92b653e9210b696765cdd885437457de1add2a9011d92f8cf63e4641bab7b";
            };
          };
        in
        drv;

      json_ld =
        let
          version = "1.0.1";
          drv = buildMix {
            inherit version;
            name = "json_ld";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "json_ld";
              sha256 = "577eba4a70087d1fd34883b04a7ad5bc5bf86e2a44fcba585fd8bb58d97935b2";
            };

            beamDeps = [
              jason
              rdf
              tesla
            ];
          };
        in
        drv;

      json_serde =
        let
          version = "1.1.1";
          drv = buildMix {
            inherit version;
            name = "json_serde";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "json_serde";
              sha256 = "0a7acdfac16efceb5337547e98418d3de083c066bbc05f3b5dd96c434d533922";
            };

            beamDeps = [
              brex_result
              decimal
              jason
            ];
          };
        in
        drv;

      jumper =
        let
          version = "1.0.2";
          drv = buildMix {
            inherit version;
            name = "jumper";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "jumper";
              sha256 = "9b7782409021e01ab3c08270e26f36eb62976a38c1aa64b2eaf6348422f165e1";
            };
          };
        in
        drv;

      lazy_html =
        let
          version = "0.1.12";
          drv = buildMix {
            inherit version;
            name = "lazy_html";
            appConfigPath = ./config;

            nativeBuildInputs = [
              lexbor
            ];

            src = fetchHex {
              inherit version;
              pkg = "lazy_html";
              sha256 = "8a0da594776caee58782c6f93b2abaa5bdb809daf8d43351a561f7de9dc2e2a8";
            };

            beamDeps = [
              cc_precompiler
              elixir_make
              fine
            ];
          };
        in
        drv.override (workarounds.lazyHtml { } drv);

      linkify =
        let
          version = "0.5.3";
          drv = buildMix {
            inherit version;
            name = "linkify";
            appConfigPath = ./config;

            src = fetchFromGitHub {
              owner = "bonfire-networks";
              repo = "linkify";
              rev = "4ee8bad879c76569240071d4a025213040b5489c";
              hash = "sha256-5FxcSlT3GQ2SzcTKhh1hc5kgZY/fSVqu9OnrcnGhZmw=";
            };

            beamDeps = [
              untangle
            ];
          };
        in
        drv;

      live_select =
        let
          version = "1.7.5";
          drv = buildMix {
            inherit version;
            name = "live_select";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "live_select";
              sha256 = "45b24b94dadee5112edb955100f0f7b9799477c7847b56eb3c0bf1ac5e293568";
            };

            beamDeps = [
              ecto
              phoenix
              phoenix_html
              phoenix_html_helpers
              phoenix_live_view
            ];
          };
        in
        drv;

      lumis =
        let
          version = "0.6.2";
          drv = buildMix {
            inherit version;
            name = "lumis";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "lumis";
              sha256 = "c58c28580574fb080b1e9f68e889fa4d26df7553b57e171a78e8424fe7f2603b";
            };

            beamDeps = [
              nimble_options
              rustler_precompiled
            ];
          };
        in
        drv.override (workarounds.rustlerPrecompiled { } drv);

      mail =
        let
          version = "0.5.2";
          drv = buildMix {
            inherit version;
            name = "mail";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "mail";
              sha256 = "f8e07c252d82528d8111c56707b51b44e8fa899cc05583ce282055b8c27a684c";
            };
          };
        in
        drv;

      makeup =
        let
          version = "1.2.2";
          drv = buildMix {
            inherit version;
            name = "makeup";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "makeup";
              sha256 = "9a1a24e5b343b8ae16abea0822c10a6f75da27af7fa802ada5251f7579bfccfa";
            };

            beamDeps = [
              nimble_parsec
            ];
          };
        in
        drv;

      makeup_diff =
        let
          version = "0.1.1";
          drv = buildMix {
            inherit version;
            name = "makeup_diff";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "makeup_diff";
              sha256 = "fadb0bf014bd328badb7be986eadbce1a29955dd51c27a9e401c3045cf24184e";
            };

            beamDeps = [
              makeup
            ];
          };
        in
        drv;

      makeup_eex =
        let
          version = "2.0.2";
          drv = buildMix {
            inherit version;
            name = "makeup_eex";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "makeup_eex";
              sha256 = "30ac121dda580298ff3378324ffaec94aad5a5b67e0cc6af177c67d5f45629b9";
            };

            beamDeps = [
              makeup
              makeup_elixir
              makeup_html
              nimble_parsec
            ];
          };
        in
        drv;

      makeup_elixir =
        let
          version = "1.0.1";
          drv = buildMix {
            inherit version;
            name = "makeup_elixir";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "makeup_elixir";
              sha256 = "7284900d412a3e5cfd97fdaed4f5ed389b8f2b4cb49efc0eb3bd10e2febf9507";
            };

            beamDeps = [
              makeup
              nimble_parsec
            ];
          };
        in
        drv;

      makeup_erlang =
        let
          version = "1.1.0";
          drv = buildMix {
            inherit version;
            name = "makeup_erlang";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "makeup_erlang";
              sha256 = "1cd6780fb1dd1a03979abaed0fe82712b0625118fd5257d3ebbf73f960c73c3c";
            };

            beamDeps = [
              makeup
            ];
          };
        in
        drv;

      makeup_graphql =
        let
          version = "0.1.2";
          drv = buildMix {
            inherit version;
            name = "makeup_graphql";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "makeup_graphql";
              sha256 = "3390ab04ba388d52a94bbe64ef62aa4d7923ceaffac43ec948f58f631440e8fb";
            };

            beamDeps = [
              makeup
              nimble_parsec
            ];
          };
        in
        drv;

      makeup_html =
        let
          version = "0.2.0";
          drv = buildMix {
            inherit version;
            name = "makeup_html";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "makeup_html";
              sha256 = "0856f7beb9a6a642ab1307e06d990fe39f0ba58690d0b8e662aa2e027ba331b2";
            };

            beamDeps = [
              makeup
            ];
          };
        in
        drv;

      makeup_js =
        let
          version = "0.1.0";
          drv = buildMix {
            inherit version;
            name = "makeup_js";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "makeup_js";
              sha256 = "3f0c1a5eb52c9737b1679c926574e83bb260ccdedf08b58ee96cca7c685dea75";
            };

            beamDeps = [
              makeup
            ];
          };
        in
        drv;

      makeup_json =
        let
          version = "1.0.0";
          drv = buildMix {
            inherit version;
            name = "makeup_json";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "makeup_json";
              sha256 = "5c8c559e658c7f7e91b96c4b8c40f5912ea0adff44b7afe73e4639d9c3f53b94";
            };

            beamDeps = [
              makeup
              nimble_parsec
            ];
          };
        in
        drv;

      makeup_sql =
        let
          version = "0.1.3";
          drv = buildMix {
            inherit version;
            name = "makeup_sql";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "makeup_sql";
              sha256 = "a9ec32cc16399b3b5a86565a289bab3fe56f6f789366358e15ee133ed71dddd4";
            };

            beamDeps = [
              makeup
              nimble_parsec
            ];
          };
        in
        drv;

      markdown_formatter =
        let
          version = "0.6.0";
          drv = buildMix {
            inherit version;
            name = "markdown_formatter";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "markdown_formatter";
              sha256 = "8181c6c1516061de482e24fa69e287878bab88249dae4ca489d89e914040da90";
            };

            beamDeps = [
              earmark_parser
            ];
          };
        in
        drv;

      mdex =
        let
          version = "0.13.4";
          drv = buildMix {
            inherit version;
            name = "mdex";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "mdex";
              sha256 = "915e579df919923c0685e6ea9851cf6e4a346d014795f03ce5a1a9c52455192b";
            };

            beamDeps = [
              jason
              lumis
              mdex_native
              nimble_options
              nimble_parsec
              phoenix_live_view
            ];
          };
        in
        drv;

      mdex_native =
        let
          version = "0.2.6";
          drv = buildMix {
            inherit version;
            name = "mdex_native";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "mdex_native";
              sha256 = "eaaf2af27162c9879f5aef66344101dadf1898e71ea6ac9eb811c8d92d8e49ad";
            };

            beamDeps = [
              rustler_precompiled
            ];
          };
        in
        drv.override (workarounds.rustlerPrecompiled { } drv);

      metrics =
        let
          version = "1.0.1";
          drv = buildRebar3 {
            inherit version;
            name = "metrics";

            src = fetchHex {
              inherit version;
              pkg = "metrics";
              sha256 = "69b09adddc4f74a40716ae54d140f93beb0fb8978d8636eaded0c31b6f099f16";
            };
          };
        in
        drv;

      mime =
        let
          version = "2.0.7";
          drv = buildMix {
            inherit version;
            name = "mime";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "mime";
              sha256 = "6171188e399ee16023ffc5b76ce445eb6d9672e2e241d2df6050f3c771e80ccd";
            };
          };
        in
        drv;

      mimerl =
        let
          version = "1.5.0";
          drv = buildRebar3 {
            inherit version;
            name = "mimerl";

            src = fetchHex {
              inherit version;
              pkg = "mimerl";
              sha256 = "db648ce065bae14ea84ca8b5dd123f42f49417cef693541110bf6f9e9be9ecc4";
            };
          };
        in
        drv;

      mimetype_parser =
        let
          version = "0.1.3";
          drv = buildMix {
            inherit version;
            name = "mimetype_parser";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "mimetype_parser";
              sha256 = "7d8f80c567807ce78cd93c938e7f4b0a20b1aaaaab914bf286f68457d9f7a852";
            };
          };
        in
        drv;

      mint =
        let
          version = "1.9.3";
          drv = buildMix {
            inherit version;
            name = "mint";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "mint";
              sha256 = "5f7c9342480c069dbbc4eeac3490303c9e01870ff01a7f1d29b6107054fc1e74";
            };

            beamDeps = [
              castore
              hpax
            ];
          };
        in
        drv;

      mjml =
        let
          version = "5.3.1";
          drv = buildMix {
            inherit version;
            name = "mjml";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "mjml";
              sha256 = "e8878f1aabd162c21fc2ae588f6be015ed14dd98400ba9fc67d1dca1e6a10da5";
            };

            beamDeps = [
              rustler_precompiled
            ];
          };
        in
        drv.override (workarounds.rustlerPrecompiled { } drv);

      mochiweb =
        let
          version = "3.4.0";
          drv = buildRebar3 {
            inherit version;
            name = "mochiweb";

            src = fetchHex {
              inherit version;
              pkg = "mochiweb";
              sha256 = "f07586c67e5d6a76120aebccb86bf123b8d153b2744d3a6acdd7e91853535674";
            };
          };
        in
        drv;

      mogrify =
        let
          version = "0.9.3";
          drv = buildMix {
            inherit version;
            name = "mogrify";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "mogrify";
              sha256 = "0189b1e1de27455f2b9ae8cf88239cefd23d38de9276eb5add7159aea51731e6";
            };
          };
        in
        drv;

      mua =
        let
          version = "0.2.6";
          drv = buildMix {
            inherit version;
            name = "mua";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "mua";
              sha256 = "c8bd1417dc18208eed3a3e0f1b847930e7b649e3e71165d2934f3b1ba62b3c18";
            };

            beamDeps = [
              castore
            ];
          };
        in
        drv;

      multipart =
        let
          version = "0.6.1";
          drv = buildMix {
            inherit version;
            name = "multipart";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "multipart";
              sha256 = "7cf21bf69885a0549fe7735b26c504acdf89fe576095cb40c61e970fbf724862";
            };

            beamDeps = [
              mime
            ];
          };
        in
        drv;

      nebulex =
        let
          version = "3.0.4";
          drv = buildMix {
            inherit version;
            name = "nebulex";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "nebulex";
              sha256 = "446afc6d3f701ba991f1fb0eee36c600f888530e52f30f80b308480ad65faab6";
            };

            beamDeps = [
              decorator
              nimble_options
              telemetry
            ];
          };
        in
        drv;

      nebulex_disk_lfu =
        let
          version = "3.0.0";
          drv = buildMix {
            inherit version;
            name = "nebulex_disk_lfu";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "nebulex_disk_lfu";
              sha256 = "85fc09dfec2845f519784478fa3ebfa57a49a50b70234f164d59930cdf79e50c";
            };

            beamDeps = [
              nebulex
              nebulex_local
              nimble_options
              telemetry
            ];
          };
        in
        drv;

      nebulex_distributed =
        let
          version = "3.2.3";
          drv = buildMix {
            inherit version;
            name = "nebulex_distributed";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "nebulex_distributed";
              sha256 = "67a353fb5d67506767667d816d9f8a46a813549ba74e74bb0a1a0d83a078abff";
            };

            beamDeps = [
              ex_hash_ring
              nebulex
              nebulex_local
              nebulex_streams
              partitioned_buffer
              telemetry
            ];
          };
        in
        drv;

      nebulex_local =
        let
          version = "3.0.0";
          drv = buildMix {
            inherit version;
            name = "nebulex_local";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "nebulex_local";
              sha256 = "7a087d9f071369ba272cd688c2bc4b758926ab3a2e239bce1b529653a14bdad1";
            };

            beamDeps = [
              ex2ms
              nebulex
              nimble_options
              telemetry
            ];
          };
        in
        drv;

      nebulex_streams =
        let
          version = "0.2.0";
          drv = buildMix {
            inherit version;
            name = "nebulex_streams";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "nebulex_streams";
              sha256 = "4cd38507756d16fa314cadf4452ea6c501fa49a77bf9bf2c46719b84c83d8d20";
            };

            beamDeps = [
              nebulex
              nimble_options
              phoenix_pubsub
              telemetry
            ];
          };
        in
        drv;

      needle =
        let
          version = "0.9.0";
          drv = buildMix {
            inherit version;
            name = "needle";
            appConfigPath = ./config;

            src = fetchFromGitHub {
              owner = "bonfire-networks";
              repo = "needle";
              rev = "502c72ae628cf1e2458a3cbdb499ec6be048ce33";
              hash = "sha256-dNOmbwhAUhvpmebgUVhiEYP9xCsLUZabO8mQRjMcckc=";
            };

            beamDeps = [
              ecto_sql
              typed_ecto_schema
              exto
              needle_uid
              telemetry
            ];
          };
        in
        drv;

      needle_uid =
        let
          version = "0.0.2";
          drv = buildMix {
            inherit version;
            name = "needle_uid";
            appConfigPath = ./config;

            src = fetchFromGitHub {
              owner = "bonfire-networks";
              repo = "needle_uid";
              rev = "ca0cd30a880fd5d2ef856763c1b8f1af603a7f06";
              hash = "sha256-dn9XnodcI3BJAv46nUV1As/AKCAxXQ25DBRpHS8eXBk=";
            };

            beamDeps = [
              ecto
              untangle
              needle_ulid
            ];
          };
        in
        drv;

      needle_ulid =
        let
          version = "0.5.0";
          drv = buildMix {
            inherit version;
            name = "needle_ulid";
            appConfigPath = ./config;

            src = fetchFromGitHub {
              owner = "bonfire-networks";
              repo = "needle_ulid";
              rev = "c48e90be2072b24fddf5f515bdac7af1fbd6d7cf";
              hash = "sha256-5ia6u4OMeAiBHV23YchEF83E7NTKS7KssgoUi90bnbk=";
            };

            beamDeps = [
              ex_ulid
              uniq
              ecto
              ecto_sql
            ];
          };
        in
        drv;

      nimble_csv =
        let
          version = "1.3.0";
          drv = buildMix {
            inherit version;
            name = "nimble_csv";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "nimble_csv";
              sha256 = "41ccdc18f7c8f8bb06e84164fc51635321e80d5a3b450761c4997d620925d619";
            };
          };
        in
        drv;

      nimble_options =
        let
          version = "1.1.1";
          drv = buildMix {
            inherit version;
            name = "nimble_options";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "nimble_options";
              sha256 = "821b2470ca9442c4b6984882fe9bb0389371b8ddec4d45a9504f00a66f650b44";
            };
          };
        in
        drv;

      nimble_ownership =
        let
          version = "1.0.2";
          drv = buildMix {
            inherit version;
            name = "nimble_ownership";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "nimble_ownership";
              sha256 = "098af64e1f6f8609c6672127cfe9e9590a5d3fcdd82bc17a377b8692fd81a879";
            };
          };
        in
        drv;

      nimble_parsec =
        let
          version = "1.4.2";
          drv = buildMix {
            inherit version;
            name = "nimble_parsec";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "nimble_parsec";
              sha256 = "4b21398942dda052b403bbe1da991ccd03a053668d147d53fb8c4e0efe09c973";
            };
          };
        in
        drv;

      nimble_pool =
        let
          version = "1.1.0";
          drv = buildMix {
            inherit version;
            name = "nimble_pool";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "nimble_pool";
              sha256 = "af2e4e6b34197db81f7aad230c1118eac993acc0dae6bc83bac0126d4ae0813a";
            };
          };
        in
        drv;

      nodeinfo =
        let
          version = "0.1.0";
          drv = buildMix {
            inherit version;
            name = "nodeinfo";
            appConfigPath = ./config;

            src = fetchFromGitHub {
              owner = "bonfire-networks";
              repo = "nodeinfo";
              rev = "77a9dcc45c706e53ba38d7db7d0b2de1e8c082a6";
              hash = "sha256-Uv541jFayb9P4KK/doMY4ClUDkMq+RLrQns2vcYbvgg=";
            };

            beamDeps = [
              phoenix
              postgrex
              gettext
              jason
              plug_cowboy
            ];
          };
        in
        drv;

      nx =
        let
          version = "0.13.0";
          drv = buildMix {
            inherit version;
            name = "nx";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "nx";
              sha256 = "38d2f37ee7e2f3aaa86b96f125643ffbca56a89576cd24d83b452597397b4fbd";
            };

            beamDeps = [
              complex
              telemetry
            ];
          };
        in
        drv;

      nx_image =
        let
          version = "0.1.2";
          drv = buildMix {
            inherit version;
            name = "nx_image";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "nx_image";
              sha256 = "9161863c42405ddccb6dbbbeae078ad23e30201509cc804b3b3a7c9e98764b81";
            };

            beamDeps = [
              nx
            ];
          };
        in
        drv;

      nx_signal =
        let
          version = "0.2.0";
          drv = buildMix {
            inherit version;
            name = "nx_signal";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "nx_signal";
              sha256 = "7247e5e18a177a59c4cb5355952900c62fdeadeb2bad02a9a34237b68744e2bb";
            };

            beamDeps = [
              nx
            ];
          };
        in
        drv;

      oban =
        let
          version = "2.23.0";
          drv = buildMix {
            inherit version;
            name = "oban";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "oban";
              sha256 = "8e5f0cec5abecce78dd08cb14dc5438db90ec3884987b44773ce76fe60dd3f81";
            };

            beamDeps = [
              ecto_sql
              igniter
              jason
              postgrex
              telemetry
            ];
          };
        in
        drv;

      oban_met =
        let
          version = "1.2.0";
          drv = buildMix {
            inherit version;
            name = "oban_met";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "oban_met";
              sha256 = "5c81fd33beeb172603cf83bea760298eeb8709d584fbe79ae2d07b09917d6110";
            };

            beamDeps = [
              oban
            ];
          };
        in
        drv;

      oban_web =
        let
          version = "2.12.6";
          drv = buildMix {
            inherit version;
            name = "oban_web";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "oban_web";
              sha256 = "1ade7bbbde1a731c9e4aa23f9f7c8a3f2871e734c6bc46fa4e4384688a69921d";
            };

            beamDeps = [
              jason
              oban
              oban_met
              phoenix
              phoenix_html
              phoenix_live_view
              phoenix_pubsub
            ];
          };
        in
        drv;

      opentelemetry =
        let
          version = "1.7.0";
          drv = buildRebar3 {
            inherit version;
            name = "opentelemetry";

            src = fetchHex {
              inherit version;
              pkg = "opentelemetry";
              sha256 = "a9173b058c4549bf824cbc2f1d2fa2adc5cdedc22aa3f0f826951187bbd53131";
            };

            beamDeps = [
              opentelemetry_api
            ];
          };
        in
        drv;

      opentelemetry_api =
        let
          version = "1.5.0";
          drv = buildMix {
            inherit version;
            name = "opentelemetry_api";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "opentelemetry_api";
              sha256 = "f53ec8a1337ae4a487d43ac89da4bd3a3c99ddf576655d071deed8b56a2d5dda";
            };
          };
        in
        drv;

      opentelemetry_exporter =
        let
          version = "1.10.0";
          drv = buildRebar3 {
            inherit version;
            name = "opentelemetry_exporter";

            src = fetchHex {
              inherit version;
              pkg = "opentelemetry_exporter";
              sha256 = "33a116ed7304cb91783f779dec02478f887c87988077bfd72840f760b8d4b952";
            };

            beamDeps = [
              grpcbox
              opentelemetry
              opentelemetry_api
              tls_certificate_check
            ];
          };
        in
        drv;

      opentelemetry_process_propagator =
        let
          version = "0.3.0";
          drv = buildMix {
            inherit version;
            name = "opentelemetry_process_propagator";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "opentelemetry_process_propagator";
              sha256 = "7243cb6de1523c473cba5b1aefa3f85e1ff8cc75d08f367104c1e11919c8c029";
            };

            beamDeps = [
              opentelemetry_api
            ];
          };
        in
        drv;

      opentelemetry_semantic_conventions =
        let
          version = "1.27.0";
          drv = buildMix {
            inherit version;
            name = "opentelemetry_semantic_conventions";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "opentelemetry_semantic_conventions";
              sha256 = "9681ccaa24fd3d810b4461581717661fd85ff7019b082c2dff89c7d5b1fc2864";
            };
          };
        in
        drv;

      orion =
        let
          version = "1.0.7";
          drv = buildMix {
            inherit version;
            name = "orion";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "orion";
              sha256 = "e8096ac94d684c0b80d3fbeb704243bb4b349831755bbe145f7814bba186aab4";
            };

            beamDeps = [
              dog_sketch
              jason
              orion_collector
              phoenix_html_helpers
              phoenix_live_view
            ];
          };
        in
        drv;

      orion_collector =
        let
          version = "1.2.0";
          drv = buildMix {
            inherit version;
            name = "orion_collector";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "orion_collector";
              sha256 = "f6eb4687123c5845da2bb82002babdaf87ccb8ddb3762cde304aa09f24832422";
            };

            beamDeps = [
              dog_sketch
              ex2ms
            ];
          };
        in
        drv;

      owl =
        let
          version = "0.13.1";
          drv = buildMix {
            inherit version;
            name = "owl";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "owl";
              sha256 = "351e768af8f2edc575cdaab1a5a2f6d6381be591758a026c701c703145508a0c";
            };
          };
        in
        drv;

      paginator =
        let
          version = "1.0.4";
          drv = buildMix {
            inherit version;
            name = "paginator";
            appConfigPath = ./config;

            src = fetchFromGitHub {
              owner = "bonfire-networks";
              repo = "paginator";
              rev = "a8745110d35ab83ceb0eb21db12ecab1d2494274";
              hash = "sha256-88UXs71SpsI9Z1Fz1lKmeNojG2gTp+18R7f/mzDnPg4=";
            };

            beamDeps = [
              ecto
              ecto_sql
              postgrex
              plug_crypto
              needle_uid
              untangle
            ];
          };
        in
        drv;

      pane =
        let
          version = "0.5.1";
          drv = buildMix {
            inherit version;
            name = "pane";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "pane";
              sha256 = "7040e79f99306b3335d452667bd767805b020fcc35acd5c21e5a56650b0f0b00";
            };
          };
        in
        drv;

      paper_trail =
        let
          version = "1.1.2";
          drv = buildMix {
            inherit version;
            name = "paper_trail";
            appConfigPath = ./config;

            src = fetchFromGitHub {
              owner = "bonfire-networks";
              repo = "paper_trail";
              rev = "4a848f6e58113fd76ce920e23d76cac90ac997a3";
              hash = "sha256-qxqzrxuyBmYNIYHVsFl9hRrdAwN9jKq2UaCr+o0A+Rc=";
            };

            beamDeps = [
              ecto
              ecto_sql
            ];
          };
        in
        drv;

      parse_trans =
        let
          version = "3.4.1";
          drv = buildRebar3 {
            inherit version;
            name = "parse_trans";

            src = fetchHex {
              inherit version;
              pkg = "parse_trans";
              sha256 = "620a406ce75dada827b82e453c19cf06776be266f5a67cff34e1ef2cbb60e49a";
            };
          };
        in
        drv;

      partitioned_buffer =
        let
          version = "0.4.3";
          drv = buildMix {
            inherit version;
            name = "partitioned_buffer";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "partitioned_buffer";
              sha256 = "79d33f27d859b00f2e4e3a01261f8af01a0e8b96ea04d1ae76c971f3a920cc31";
            };

            beamDeps = [
              nimble_options
              telemetry
            ];
          };
        in
        drv;

      patch =
        let
          version = "0.16.0";
          drv = buildMix {
            inherit version;
            name = "patch";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "patch";
              sha256 = "50e06ef77a9b4987edfc717a9bf047429f3d69af397a42d9ff311f27ccb23408";
            };
          };
        in
        drv;

      pathex =
        let
          version = "2.6.1";
          drv = buildMix {
            inherit version;
            name = "pathex";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "pathex";
              sha256 = "159f8e4b5fa2eaa887777070f7a5d3006601f7085efb4d76c0cef0f2ec9c4be9";
            };
          };
        in
        drv;

      phoenix =
        let
          version = "1.8.9";
          drv = buildMix {
            inherit version;
            name = "phoenix";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "phoenix";
              sha256 = "3477e2dd5a4f61820341169031bdfe21275f659923bea9c5c0ea2aa1c3fcc046";
            };

            beamDeps = [
              bandit
              jason
              phoenix_pubsub
              phoenix_template
              phoenix_view
              plug
              plug_cowboy
              plug_crypto
              telemetry
              websock_adapter
            ];
          };
        in
        drv;

      phoenix_ecto =
        let
          version = "4.7.0";
          drv = buildMix {
            inherit version;
            name = "phoenix_ecto";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "phoenix_ecto";
              sha256 = "1d75011e4254cb4ddf823e81823a9629559a1be93b4321a6a5f11a5306fbf4cc";
            };

            beamDeps = [
              ecto
              phoenix_html
              plug
              postgrex
            ];
          };
        in
        drv;

      phoenix_gon =
        let
          version = "0.4.0";
          drv = buildMix {
            inherit version;
            name = "phoenix_gon";
            appConfigPath = ./config;

            src = fetchFromGitHub {
              owner = "bonfire-networks";
              repo = "phoenix_gon";
              rev = "b7edb362aa57ae97a6340d2130a4a35c127f06d5";
              hash = "sha256-xnq09T9dqAiNutOBy9NpclEKJ3ogn/cIN1ET2zItHjg=";
            };

            beamDeps = [
              jason
              phoenix_html
              phoenix_html_helpers
              plug
              recase
            ];
          };
        in
        drv;

      phoenix_html =
        let
          version = "4.3.0";
          drv = buildMix {
            inherit version;
            name = "phoenix_html";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "phoenix_html";
              sha256 = "3eaa290a78bab0f075f791a46a981bbe769d94bc776869f4f3063a14f30497ad";
            };
          };
        in
        drv;

      phoenix_html_helpers =
        let
          version = "1.0.1";
          drv = buildMix {
            inherit version;
            name = "phoenix_html_helpers";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "phoenix_html_helpers";
              sha256 = "cffd2385d1fa4f78b04432df69ab8da63dc5cf63e07b713a4dcf36a3740e3090";
            };

            beamDeps = [
              phoenix_html
              plug
            ];
          };
        in
        drv;

      phoenix_live_dashboard =
        let
          version = "0.8.7";
          drv = buildMix {
            inherit version;
            name = "phoenix_live_dashboard";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "phoenix_live_dashboard";
              sha256 = "3a8625cab39ec261d48a13b7468dc619c0ede099601b084e343968309bd4d7d7";
            };

            beamDeps = [
              ecto
              ecto_psql_extras
              mime
              phoenix_live_view
              telemetry_metrics
            ];
          };
        in
        drv;

      phoenix_live_favicon =
        let
          version = "1.0.0";
          drv = buildMix {
            inherit version;
            name = "phoenix_live_favicon";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "phoenix_live_favicon";
              sha256 = "fcc012441ddeb357d4008d7dae1873cb312c8b15cf725f7dad53834facfc53f1";
            };

            beamDeps = [
              phoenix_live_head
            ];
          };
        in
        drv;

      phoenix_live_head =
        let
          version = "1.0.0";
          drv = buildMix {
            inherit version;
            name = "phoenix_live_head";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "phoenix_live_head";
              sha256 = "51d1b6a62f516f10f84217b59736684f027bb0dc355cc0d81983c8f9a3cce18b";
            };

            beamDeps = [
              ex_doc
              jason
              phoenix
              phoenix_html
              phoenix_live_view
            ];
          };
        in
        drv;

      phoenix_live_view =
        let
          version = "1.2.8";
          drv = buildMix {
            inherit version;
            name = "phoenix_live_view";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "phoenix_live_view";
              sha256 = "b05ffe21f43c0ff219da62948b482c324aa5b8873e17b0c0cac58289a178af38";
            };

            beamDeps = [
              igniter
              jason
              lazy_html
              phoenix
              phoenix_html
              phoenix_template
              phoenix_view
              plug
              telemetry
            ];
          };
        in
        drv;

      phoenix_pubsub =
        let
          version = "2.2.0";
          drv = buildMix {
            inherit version;
            name = "phoenix_pubsub";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "phoenix_pubsub";
              sha256 = "adc313a5bf7136039f63cfd9668fde73bba0765e0614cba80c06ac9460ff3e96";
            };
          };
        in
        drv;

      phoenix_seo =
        let
          version = "0.2.1";
          drv = buildMix {
            inherit version;
            name = "phoenix_seo";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "phoenix_seo";
              sha256 = "78fa241ed6f7a099ec015c77e18f314c7931ac73a95ccdca63ff9879738dc56e";
            };

            beamDeps = [
              phoenix_live_view
            ];
          };
        in
        drv;

      phoenix_swoosh =
        let
          version = "1.2.1";
          drv = buildMix {
            inherit version;
            name = "phoenix_swoosh";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "phoenix_swoosh";
              sha256 = "4000eeba3f9d7d1a6bf56d2bd56733d5cadf41a7f0d8ffe5bb67e7d667e204a2";
            };

            beamDeps = [
              finch
              hackney
              phoenix
              phoenix_html
              phoenix_view
              swoosh
            ];
          };
        in
        drv;

      phoenix_template =
        let
          version = "1.0.4";
          drv = buildMix {
            inherit version;
            name = "phoenix_template";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "phoenix_template";
              sha256 = "2c0c81f0e5c6753faf5cca2f229c9709919aba34fab866d3bc05060c9c444206";
            };

            beamDeps = [
              phoenix_html
            ];
          };
        in
        drv;

      phoenix_view =
        let
          version = "2.0.4";
          drv = buildMix {
            inherit version;
            name = "phoenix_view";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "phoenix_view";
              sha256 = "4e992022ce14f31fe57335db27a28154afcc94e9983266835bb3040243eb620b";
            };

            beamDeps = [
              phoenix_html
              phoenix_template
            ];
          };
        in
        drv;

      plausible_proxy =
        let
          version = "0.1.1";
          drv = buildMix {
            inherit version;
            name = "plausible_proxy";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "plausible_proxy";
              sha256 = "8cc561fec3f085d5121bfcf8f1846678701399a12dddd0731219713bc5722d07";
            };

            beamDeps = [
              httpoison
              jason
              plug
            ];
          };
        in
        drv;

      plug =
        let
          version = "1.20.3";
          drv = buildMix {
            inherit version;
            name = "plug";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "plug";
              sha256 = "be266aee1b8536ef6409d58cf39a3121319f0ec47cfa1b24024485aa0e76ad76";
            };

            beamDeps = [
              mime
              plug_crypto
              telemetry
            ];
          };
        in
        drv;

      plug_cowboy =
        let
          version = "2.9.0";
          drv = buildMix {
            inherit version;
            name = "plug_cowboy";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "plug_cowboy";
              sha256 = "2002bafba4f3a45b55a58e68d70211b153a7ed18d37edb1ceb6e96e7a92c422e";
            };

            beamDeps = [
              cowboy
              cowboy_telemetry
              plug
            ];
          };
        in
        drv;

      plug_crypto =
        let
          version = "2.2.0";
          drv = buildMix {
            inherit version;
            name = "plug_crypto";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "plug_crypto";
              sha256 = "83a95744ab1c75876542b6fab135fcc176280e0f301a111c1f757fddcec95d2c";
            };
          };
        in
        drv;

      plug_early_hints =
        let
          version = "0.1.0";
          drv = buildMix {
            inherit version;
            name = "plug_early_hints";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "plug_early_hints";
              sha256 = "f4167b2daecbe39af40718fe0907899f34ef9f19ea11fb184a4732b18dc70e3c";
            };

            beamDeps = [
              plug
            ];
          };
        in
        drv;

      plug_http_validator =
        let
          version = "0.1.0";
          drv = buildMix {
            inherit version;
            name = "plug_http_validator";
            appConfigPath = ./config;

            src = fetchFromGitHub {
              owner = "bonfire-networks";
              repo = "plug_http_validator";
              rev = "dbc277f8a328bc44107174fb1770b1376337697a";
              hash = "sha256-6O8jq0YQdT3sGN59xie5RAuGLoHtLl3Qsw3SaXccw1Y=";
            };

            beamDeps = [
              plug
            ];
          };
        in
        drv;

      poison =
        let
          version = "6.0.0";
          drv = buildMix {
            inherit version;
            name = "poison";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "poison";
              sha256 = "bb9064632b94775a3964642d6a78281c07b7be1319e0016e1643790704e739a2";
            };

            beamDeps = [
              decimal
            ];
          };
        in
        drv;

      polaris =
        let
          version = "0.1.0";
          drv = buildMix {
            inherit version;
            name = "polaris";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "polaris";
              sha256 = "13ef2b166650e533cb24b10e2f3b8ab4f2f449ba4d63156e8c569527f206e2c2";
            };

            beamDeps = [
              nx
            ];
          };
        in
        drv;

      postgrex =
        let
          version = "0.22.3";
          drv = buildMix {
            inherit version;
            name = "postgrex";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "postgrex";
              sha256 = "f018c13752b2b46e8d35d7e2d84c3276557cbfd880769109021a1d0ee36c1cfe";
            };

            beamDeps = [
              db_connection
              decimal
              jason
            ];
          };
        in
        drv;

      process_tree =
        let
          version = "0.3.0";
          drv = buildMix {
            inherit version;
            name = "process_tree";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "process_tree";
              sha256 = "6cb3b7be9c7d74b28a9f6e0f03115d5953e6bbda44be2b6fd9e667020870eb86";
            };
          };
        in
        drv;

      protocol_ex =
        let
          version = "0.5.1";
          drv = buildMix {
            inherit version;
            name = "protocol_ex";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "protocol_ex";
              sha256 = "e9f2dd9f45af3a06771e49a10c6d7fdab395b3bedcc1d0aa9322b004380857f8";
            };
          };
        in
        drv;

      ranch =
        let
          version = "2.2.1";
          drv = buildRebar3 {
            inherit version;
            name = "ranch";

            src = fetchHex {
              inherit version;
              pkg = "ranch";
              sha256 = "55f05cce20ec2da1d90de5d5981afb93dbfc01325fc7e933189aa5c62f037c24";
            };
          };
        in
        drv;

      rdf =
        let
          version = "3.0.1";
          drv = buildMix {
            inherit version;
            name = "rdf";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "rdf";
              sha256 = "1a1130bbc13fc0eec5b2fde4b065e520bb5536dde7a61f8c42c0ef79090504a2";
            };

            beamDeps = [
              decimal
              jason
              jcs
              protocol_ex
              uniq
            ];
          };
        in
        drv;

      recase =
        let
          version = "0.9.1";
          drv = buildMix {
            inherit version;
            name = "recase";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "recase";
              sha256 = "19ba03ceb811750e6bec4a015a9f9e45d16a8b9e09187f6d72c3798f454710f3";
            };
          };
        in
        drv;

      redirect =
        let
          version = "0.4.0";
          drv = buildMix {
            inherit version;
            name = "redirect";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "redirect";
              sha256 = "dfa29a8ecbad066ed0b73b34611cf24c78101719737f37bdf750f39197d67b97";
            };

            beamDeps = [
              phoenix
              plug
            ];
          };
        in
        drv;

      remote_ip =
        let
          version = "1.2.0";
          drv = buildMix {
            inherit version;
            name = "remote_ip";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "remote_ip";
              sha256 = "2ff91de19c48149ce19ed230a81d377186e4412552a597d6a5137373e5877cb7";
            };

            beamDeps = [
              combine
              plug
            ];
          };
        in
        drv;

      req =
        let
          version = "0.6.3";
          drv = buildMix {
            inherit version;
            name = "req";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "req";
              sha256 = "e85b5c6c990e6c3f52bbba68e6f099118f2b8252825f96c7c3636b97a3de307d";
            };

            beamDeps = [
              finch
              jason
              mime
              nimble_csv
              plug
            ];
          };
        in
        drv;

      rewrite =
        let
          version = "1.3.0";
          drv = buildMix {
            inherit version;
            name = "rewrite";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "rewrite";
              sha256 = "d111ac7ff3a58a802ef4f193bbd1831e00a9c57b33276e5068e8390a212714a5";
            };

            beamDeps = [
              glob_ex
              sourceror
              text_diff
            ];
          };
        in
        drv;

      rustler_precompiled =
        let
          version = "0.9.0";
          drv = buildMix {
            inherit version;
            name = "rustler_precompiled";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "rustler_precompiled";
              sha256 = "471d97315bd3bf7b64623418b3693eedd8e47de3d1cb79a0ac8f9da7d770d94c";
            };
          };
        in
        drv;

      safetensors =
        let
          version = "0.1.3";
          drv = buildMix {
            inherit version;
            name = "safetensors";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "safetensors";
              sha256 = "fe50b53ea59fde4e723dd1a2e31cfdc6013e69343afac84c6be86d6d7c562c14";
            };

            beamDeps = [
              jason
              nx
            ];
          };
        in
        drv;

      scribe =
        let
          version = "0.11.1";
          drv = buildMix {
            inherit version;
            name = "scribe";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "scribe";
              sha256 = "f1433b6dc51fc76776e26764a087e991062419d08adb79d8e305efc34d07b773";
            };

            beamDeps = [
              pane
            ];
          };
        in
        drv;

      sentry =
        let
          version = "13.2.0";
          drv = buildMix {
            inherit version;
            name = "sentry";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "sentry";
              sha256 = "f3397760ba0f0a2d8abb969c3e9f95e909839f7c45957249ee229c0e9738a3b4";
            };

            beamDeps = [
              finch
              hackney
              igniter
              jason
              nimble_options
              nimble_ownership
              opentelemetry
              opentelemetry_api
              opentelemetry_exporter
              opentelemetry_semantic_conventions
              phoenix
              phoenix_live_view
              plug
              telemetry
            ];
          };
        in
        drv;

      simple_slug =
        let
          version = "0.1.1";
          drv = buildMix {
            inherit version;
            name = "simple_slug";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "simple_slug";
              sha256 = "477c19c7bc8755a1378bdd4ec591e4819071c72353b7e470b90329e63ef67a72";
            };
          };
        in
        drv;

      sizeable =
        let
          version = "1.0.2";
          drv = buildMix {
            inherit version;
            name = "sizeable";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "sizeable";
              sha256 = "4bab548e6dfba777b400ca50830a9e3a4128e73df77ab1582540cf5860601762";
            };
          };
        in
        drv;

      sleeplocks =
        let
          version = "1.1.4";
          drv = buildRebar3 {
            inherit version;
            name = "sleeplocks";

            src = fetchHex {
              inherit version;
              pkg = "sleeplocks";
              sha256 = "bc12752ab0693ea4e4a3bcf4e063cef408d71197a3c0fad75497fabd475f5481";
            };
          };
        in
        drv;

      solid =
        let
          version = "0.18.0";
          drv = buildMix {
            inherit version;
            name = "solid";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "solid";
              sha256 = "7704681c11c880308fe1337acf7690083f884076b612d38b7dccb5a1bd016068";
            };

            beamDeps = [
              nimble_parsec
            ];
          };
        in
        drv;

      sourceror =
        let
          version = "1.12.2";
          drv = buildMix {
            inherit version;
            name = "sourceror";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "sourceror";
              sha256 = "da37d3da09c5b890528802c7056a8f585a061973820d7656b6e3649c14f0e9cb";
            };
          };
        in
        drv;

      spitfire =
        let
          version = "0.4.0";
          drv = buildMix {
            inherit version;
            name = "spitfire";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "spitfire";
              sha256 = "7e5c6d1523c111b59f332f9dc49edc0377111d0c17167a29830f0e98233f5472";
            };
          };
        in
        drv;

      ssl_verify_fun =
        let
          version = "1.1.7";
          drv = buildMix {
            inherit version;
            name = "ssl_verify_fun";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "ssl_verify_fun";
              sha256 = "fe4c190e8f37401d30167c8c405eda19469f34577987c76dde613e838bbc67f8";
            };
          };
        in
        drv;

      statistex =
        let
          version = "1.1.1";
          drv = buildMix {
            inherit version;
            name = "statistex";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "statistex";
              sha256 = "310c4b49b34adf683de3103639006bed233ab54c08a4add65a531448e653857c";
            };
          };
        in
        drv;

      surf_context =
        let
          version = "0.1.0";
          drv = buildMix {
            inherit version;
            name = "surf_context";
            appConfigPath = ./config;

            src = fetchFromGitHub {
              owner = "bonfire-networks";
              repo = "surf_context";
              rev = "450a7b865870b5b53f160a24572d8160e670d2b6";
              hash = "sha256-IrjA+YdX4YQkkbBW3SiIysWZOr9j3YzJmMuJ3W6mz90=";
            };

            beamDeps = [
              phoenix_live_view
              plug
            ];
          };
        in
        drv;

      surf_live_attr =
        let
          version = "0.1.0";
          drv = buildMix {
            inherit version;
            name = "surf_live_attr";
            appConfigPath = ./config;

            src = fetchFromGitHub {
              owner = "bonfire-networks";
              repo = "surf_live_attr";
              rev = "2a5dcd9fe1c2a8d43e8f5fc9cf300c296fb70a3b";
              hash = "sha256-Msm4UXUnkw6KPr/ldZCoaQGBMmZ61apSIr3JmNXJysY=";
            };

            beamDeps = [
              phoenix_live_view
            ];
          };
        in
        drv;

      surface =
        let
          version = "0.12.3";
          drv = buildMix {
            inherit version;
            name = "surface";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "surface";
              sha256 = "ff9ad9da601e103dd31eab9afc42f2c918de47857c256dea451036b133c0158a";
            };

            beamDeps = [
              phoenix_live_view
              sourceror
            ];
          };
        in
        drv;

      surface_form_helpers =
        let
          version = "0.2.0";
          drv = buildMix {
            inherit version;
            name = "surface_form_helpers";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "surface_form_helpers";
              sha256 = "3491b2c5e5e2f6f1d004bd989557d8df750bf48cc4660671c31b8b07c44dfc22";
            };

            beamDeps = [
              phoenix_html
              phoenix_html_helpers
              surface
            ];
          };
        in
        drv;

      sweet_xml =
        let
          version = "0.7.5";
          drv = buildMix {
            inherit version;
            name = "sweet_xml";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "sweet_xml";
              sha256 = "193b28a9b12891cae351d81a0cead165ffe67df1b73fe5866d10629f4faefb12";
            };
          };
        in
        drv;

      swoosh =
        let
          version = "1.26.3";
          drv = buildMix {
            inherit version;
            name = "swoosh";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "swoosh";
              sha256 = "c7683d070fe8f8aa9d174e61b01f2d527be73cd8ac40037b7109184941eb569f";
            };

            beamDeps = [
              bandit
              cowboy
              ex_aws
              finch
              gen_smtp
              hackney
              idna
              jason
              mail
              mime
              mua
              multipart
              plug
              plug_cowboy
              req
              telemetry
            ];
          };
        in
        drv;

      table_rex =
        let
          version = "4.1.0";
          drv = buildMix {
            inherit version;
            name = "table_rex";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "table_rex";
              sha256 = "95932701df195d43bc2d1c6531178fc8338aa8f38c80f098504d529c43bc2601";
            };
          };
        in
        drv;

      telemetry =
        let
          version = "1.4.2";
          drv = buildRebar3 {
            inherit version;
            name = "telemetry";

            src = fetchHex {
              inherit version;
              pkg = "telemetry";
              sha256 = "928f6495066506077862c0d1646609eed891a4326bee3126ba54b60af61febb1";
            };
          };
        in
        drv;

      telemetry_metrics =
        let
          version = "1.1.0";
          drv = buildMix {
            inherit version;
            name = "telemetry_metrics";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "telemetry_metrics";
              sha256 = "e7b79e8ddfde70adb6db8a6623d1778ec66401f366e9a8f5dd0955c56bc8ce67";
            };

            beamDeps = [
              telemetry
            ];
          };
        in
        drv;

      telemetry_poller =
        let
          version = "1.3.0";
          drv = buildRebar3 {
            inherit version;
            name = "telemetry_poller";

            src = fetchHex {
              inherit version;
              pkg = "telemetry_poller";
              sha256 = "51f18bed7128544a50f75897db9974436ea9bfba560420b646af27a9a9b35211";
            };

            beamDeps = [
              telemetry
            ];
          };
        in
        drv;

      tesla =
        let
          version = "1.20.0";
          drv = buildMix {
            inherit version;
            name = "tesla";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "tesla";
              sha256 = "3ecb41cb458772332752c3acdfe983e23abb991f5a43cfd69a64e9ea3f4b0061";
            };

            beamDeps = [
              castore
              finch
              hackney
              jason
              mime
              mint
              opentelemetry_semantic_conventions
              poison
              telemetry
            ];
          };
        in
        drv;

      text =
        let
          version = "0.6.2";
          drv = buildMix {
            inherit version;
            name = "text";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "text";
              sha256 = "61b9f662f0f25a85eca791d363cfe2876f98b169442d5878a35c381c54395537";
            };

            beamDeps = [
              bumblebee
              color
              exla
              flow
              jason
              nx
              phoenix_html
              unicode
              unicode_idna
              unicode_string
              unicode_transform
            ];
          };
        in
        drv;

      text_corpus_udhr =
        let
          version = "0.1.0";
          drv = buildMix {
            inherit version;
            name = "text_corpus_udhr";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "text_corpus_udhr";
              sha256 = "056a0b6a804ef03070f89b9b2e09d3271539654f4e2c30bb7d229730262f3fb8";
            };

            beamDeps = [
              text
            ];
          };
        in
        drv;

      text_diff =
        let
          version = "0.1.0";
          drv = buildMix {
            inherit version;
            name = "text_diff";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "text_diff";
              sha256 = "d1ffaaecab338e49357b6daa82e435f877e0649041ace7755583a0ea3362dbd7";
            };
          };
        in
        drv;

      thousand_island =
        let
          version = "1.5.0";
          drv = buildMix {
            inherit version;
            name = "thousand_island";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "thousand_island";
              sha256 = "708923d40523e43cf99041ab37a0d4b0ec426ac6438fa3716ab23d919eaeb412";
            };

            beamDeps = [
              telemetry
            ];
          };
        in
        drv;

      timex =
        let
          version = "3.7.13";
          drv = buildMix {
            inherit version;
            name = "timex";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "timex";
              sha256 = "09588e0522669328e973b8b4fd8741246321b3f0d32735b589f78b136e6d4c54";
            };

            beamDeps = [
              combine
              gettext
              tzdata
            ];
          };
        in
        drv;

      tls_certificate_check =
        let
          version = "1.33.0";
          drv = buildRebar3 {
            inherit version;
            name = "tls_certificate_check";

            src = fetchHex {
              inherit version;
              pkg = "tls_certificate_check";
              sha256 = "cab9a7439e2dbfe91b38104f2d8a4b6d61dbc4d3a5ad59ac364713a88c6cfd9b";
            };

            beamDeps = [
              ssl_verify_fun
            ];
          };
        in
        drv;

      tokenizers =
        let
          version = "0.5.1";
          drv = buildMix {
            inherit version;
            name = "tokenizers";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "tokenizers";
              sha256 = "5f08d97cc7f2ed3d71d370d68120da6d3de010948ccf676c9c0eb591ba4bacc9";
            };

            beamDeps = [
              castore
              rustler_precompiled
            ];
          };
        in
        drv.override (
          workarounds.rustlerPrecompiled {
            buildInputs = [ oniguruma ];
            nativeBuildInputs = [ pkg-config ];
            env.RUSTONIG_SYSTEM_LIBONIG = "1";
          } drv
        );

      trie =
        let
          version = "2.0.7";
          drv = buildRebar3 {
            inherit version;
            name = "trie";

            src = fetchHex {
              inherit version;
              pkg = "trie";
              sha256 = "6b86092654bc6383d5c72dfbb32b466d3a70d3e95be37538bb5500ee888fa944";
            };
          };
        in
        drv;

      twinkle_star =
        let
          version = "0.1.0";
          drv = buildMix {
            inherit version;
            name = "twinkle_star";
            appConfigPath = ./config;

            src = fetchFromGitHub {
              owner = "bonfire-networks";
              repo = "twinkle_star";
              rev = "54e0992356bf8ec9bd7a0b63b900e0e0c504e9c4";
              hash = "sha256-F6Ui/V298Xl4+96xQfhfw3iXTcCnFix7bIu16ccGMzQ=";
            };

            beamDeps = [
              file_info
              ex_marcel
              hackney
            ];
          };
        in
        drv;

      typed_ecto_schema =
        let
          version = "0.4.3";
          drv = buildMix {
            inherit version;
            name = "typed_ecto_schema";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "typed_ecto_schema";
              sha256 = "dcbd9b35b9fda5fa9258e0ae629a99cf4473bd7adfb85785d3f71dfe7a9b2bc0";
            };

            beamDeps = [
              ecto
            ];
          };
        in
        drv;

      tzdata =
        let
          version = "1.1.4";
          drv = buildMix {
            inherit version;
            name = "tzdata";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "tzdata";
              sha256 = "ab48888699de8ff4a255522fd858abe81bac2e64690a375e6cb590112cf4a24e";
            };

            beamDeps = [
              hackney
            ];
          };
        in
        drv;

      unfurl =
        let
          version = "0.6.2";
          drv = buildMix {
            inherit version;
            name = "unfurl";
            appConfigPath = ./config;

            src = fetchFromGitHub {
              owner = "bonfire-networks";
              repo = "unfurl";
              rev = "eb6991fbcd262b286aa73394cc1fbd008721d096";
              hash = "sha256-mRDhKdI5yaz1E2apJhqOCe5DVI/Y+yUcZ10e5cQ7rWE=";
            };

            beamDeps = [
              tesla
              hackney
              floki
              jason
              plug_cowboy
              arrows
              untangle
              faviconic
            ];
          };
        in
        drv;

      unicode =
        let
          version = "1.22.0";
          drv = buildMix {
            inherit version;
            name = "unicode";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "unicode";
              sha256 = "32bbc46a0701b6f53fa93aab8754a12089cb846d0b6dde208bb476fe1b545fdb";
            };

            patches = [
              (writeText "unicode-accessible-data-dir.patch" ''
                diff --git a/lib/unicode.ex b/lib/unicode.ex
                index 8224c3c..3c0bb3a 100644
                --- a/lib/unicode.ex
                +++ b/lib/unicode.ex
                @@ -46,7 +46,7 @@ defmodule Unicode do
                     :hebrew | :buginese | :tifinagh

                   @doc false
                -  @data_dir Path.join(__DIR__, "../data") |> Path.expand()
                +  @data_dir "/tmp/unicode-data"
                   def data_dir do
                     @data_dir
                   end
              '')
            ];

            postUnpack = ''
              test -e /tmp/unicode-data ||
                ln -sfv ${unicode.src}/data /tmp/unicode-data
            '';
          };
        in
        drv;

      unicode_idna =
        let
          version = "0.1.0";
          drv = buildMix {
            inherit version;
            name = "unicode_idna";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "unicode_idna";
              sha256 = "67b775bbca382b0f1862be1eb3ddc457fe9cadfd72b4d3ef8104b113477de10a";
            };

            beamDeps = [
              unicode
            ];
          };
        in
        drv;

      unicode_set =
        let
          version = "1.6.1";
          drv = buildMix {
            inherit version;
            name = "unicode_set";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "unicode_set";
              sha256 = "9e31ce44bacc294348a7e0bee0cf949b5226b32846112e324732004c59d7d7a0";
            };

            beamDeps = [
              nimble_parsec
              unicode
            ];
          };
        in
        drv;

      unicode_string =
        let
          version = "2.1.0";
          drv = buildMix {
            inherit version;
            name = "unicode_string";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "unicode_string";
              sha256 = "155b9ac58db6e9e61f70f8cca6144ce7f22ca50e28f461a5c74808232de619fc";
            };

            beamDeps = [
              jason
              sweet_xml
              trie
              unicode_set
            ];

            postUnpack = ''
              test -e /tmp/unicode-data ||
                ln -sfv ${unicode.src}/data /tmp/unicode-data
            '';
          };
        in
        drv;

      unicode_transform =
        let
          version = "1.0.0";
          drv = buildMix {
            inherit version;
            name = "unicode_transform";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "unicode_transform";
              sha256 = "ea2590ccc7afe3f13295fd7d833e72c4c44615248b24edaf9cd21b15f7d337d0";
            };

            beamDeps = [
              elixir_make
              sweet_xml
              unicode_set
            ];
          };
        in
        drv.override (workarounds.elixirMake { } drv);

      unicode_util_compat =
        let
          version = "0.7.1";
          drv = buildRebar3 {
            inherit version;
            name = "unicode_util_compat";

            src = fetchHex {
              inherit version;
              pkg = "unicode_util_compat";
              sha256 = "b3a917854ce3ae233619744ad1e0102e05673136776fb2fa76234f3e03b23642";
            };
          };
        in
        drv;

      uniq =
        let
          version = "0.6.3";
          drv = buildMix {
            inherit version;
            name = "uniq";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "uniq";
              sha256 = "2b2a900d0a20f3a55d3de0bc8150495e4a71255734dfb23889991bda5aca6c7d";
            };

            beamDeps = [
              ecto
            ];
          };
        in
        drv;

      unpickler =
        let
          version = "0.1.0";
          drv = buildMix {
            inherit version;
            name = "unpickler";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "unpickler";
              sha256 = "e2b3f61e62406187ac52afead8a63bfb4e49394028993f3c4c42712743cab79e";
            };
          };
        in
        drv;

      unsafe =
        let
          version = "1.0.2";
          drv = buildMix {
            inherit version;
            name = "unsafe";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "unsafe";
              sha256 = "b485231683c3ab01a9cd44cb4a79f152c6f3bb87358439c6f68791b85c2df675";
            };
          };
        in
        drv;

      untangle =
        let
          version = "0.5.0";
          drv = buildMix {
            inherit version;
            name = "untangle";
            appConfigPath = ./config;

            src = fetchFromGitHub {
              owner = "bonfire-networks";
              repo = "untangle";
              rev = "8a292f67995b4080e29fdfe56e131bf2ef970b9a";
              hash = "sha256-1CQMgnLxvPEVMdfyQSkzg+pTUYvQ1aiCycjSQLnqT2E=";
            };

            beamDeps = [
              process_tree
              decorator
            ];
          };
        in
        drv;

      unzip =
        let
          version = "0.13.0";
          drv = buildMix {
            inherit version;
            name = "unzip";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "unzip";
              sha256 = "4bcb9892ecbf2042606b43ab685a1bffe03c14003e6246f5453db2c829237fd9";
            };
          };
        in
        drv;

      verbs =
        let
          version = "0.6.1";
          drv = buildMix {
            inherit version;
            name = "verbs";
            appConfigPath = ./config;

            src = fetchFromGitHub {
              owner = "shannonwells";
              repo = "verbs_ex";
              rev = "afa4693964dae0d9aceb60a73f1766c6d4f68d25";
              hash = "sha256-6edAt/lw4MMny8UsPmqJMEu0zrpF+9Halx4QXTUN3Ik=";
            };
          };
        in
        drv;

      vix =
        let
          version = "0.40.0";
          drv = buildMix {
            inherit version;
            name = "vix";
            appConfigPath = ./config;

            env.VIX_COMPILATION_MODE = "PLATFORM_PROVIDED_LIBVIPS";

            nativeBuildInputs = [
              pkg-config
              vips
            ];

            src = fetchHex {
              inherit version;
              pkg = "vix";
              sha256 = "342d69d41928e59588604f9035b383bf61e3b768bb3b1ed73a05eca134058d15";
            };

            beamDeps = [
              cc_precompiler
              elixir_make
            ];
          };
        in
        drv.override (workarounds.elixirMake { } drv);

      voodoo =
        let
          version = "0.1.0";
          drv = buildMix {
            inherit version;
            name = "voodoo";
            appConfigPath = ./config;

            src = fetchFromGitHub {
              owner = "bonfire-networks";
              repo = "voodoo";
              rev = "ababdf3b3b55e9044fead1dff491f888b435913b";
              hash = "sha256-Dk/u3BMf6xjg9BvqA83EwRU0fL559IoaPBGxJalDFqU=";
            };

            beamDeps = [
              untangle
            ];
          };
        in
        drv;

      waffle =
        let
          version = "1.1.10";
          drv = buildMix {
            inherit version;
            name = "waffle";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "waffle";
              sha256 = "859ba6377b78f0a51bc9596227b194f26241efbbd408bd217450c22b0f359cc4";
            };

            beamDeps = [
              ex_aws
              ex_aws_s3
              hackney
              sweet_xml
            ];
          };
        in
        drv;

      want =
        let
          version = "1.18.0";
          drv = buildMix {
            inherit version;
            name = "want";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "want";
              sha256 = "b9ac94ca249924f16f545ff6f128af53fa401349214f69788f360a3835bb9c9a";
            };
          };
        in
        drv;

      websock =
        let
          version = "0.5.3";
          drv = buildMix {
            inherit version;
            name = "websock";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "websock";
              sha256 = "6105453d7fac22c712ad66fab1d45abdf049868f253cf719b625151460b8b453";
            };
          };
        in
        drv;

      websock_adapter =
        let
          version = "0.6.0";
          drv = buildMix {
            inherit version;
            name = "websock_adapter";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "websock_adapter";
              sha256 = "50021a85bce8f203b086705d9e0c5415e2c7eb05d319111b0428fe71f9934617";
            };

            beamDeps = [
              bandit
              plug
              plug_cowboy
              websock
            ];
          };
        in
        drv;

      xla =
        let
          version = "0.10.0";
          drv = buildMix {
            inherit version;
            name = "xla";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "xla";
              sha256 = "f57d91aea6e661b52bf12239316c598679e9170628122bbd941235f040122bc6";
            };

            beamDeps = [
              elixir_make
            ];
          };
        in
        drv.override (workarounds.elixirMake { } drv);

      zest =
        let
          version = "0.1.2";
          drv = buildMix {
            inherit version;
            name = "zest";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "zest";
              sha256 = "ebe2d6acf615de286e45846a3d6daf72d7c20f2c5eefada6d8a1729256a3974a";
            };
          };
        in
        drv;

      zstream =
        let
          version = "0.6.7";
          drv = buildMix {
            inherit version;
            name = "zstream";
            appConfigPath = ./config;

            src = fetchHex {
              inherit version;
              pkg = "zstream";
              sha256 = "48c43ae0f00cfcda1ccb69c1d044755663d43b2ee8a0a65763648bf2078d634d";
            };
          };
        in
        drv;

    };
in
self
