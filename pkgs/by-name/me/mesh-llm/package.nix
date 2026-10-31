{
  lib,
  stdenv,
  rustPlatform,
  buildPackages,
  fetchPnpmDeps,
  cacert,
  cmake,
  makeBinaryWrapper,
  nodejs,
  pnpm_10,
  pnpmConfigHook,
  pkg-config,
  python3,
  curl,
  fetchurl,
  jq,
  versionCheckHook,
  skippy-native-runtime,
  rocmPackages,
  runCommand,

  config,
  cudaSupport ? config.cudaSupport,
  rocmSupport ? config.rocmSupport,
}:

let
  # The llama.cpp runtime bundles mesh-llm picks from, built here so nothing is downloaded.
  runtime =
    args:
    skippy-native-runtime.override (
      {
        cudaSupport = false;
        rocmSupport = false;
      }
      // args
    );
  runtimes = [
    (runtime { })
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ (runtime { vulkanSupport = true; }) ]
  ++ lib.optionals cudaSupport [ (runtime { cudaSupport = true; }) ]
  ++ lib.optionals rocmSupport [ (runtime { rocmSupport = true; }) ];

  # Where mesh-llm finds the bundles, and what they need it to know.
  runtimeEnvironment = lib.mergeAttrsList (map (r: r.hostEnvironment) runtimes) // {
    MESH_LLM_NATIVE_RUNTIME_BUNDLE_DIR = lib.makeSearchPath "share/mesh-llm/runtimes" runtimes;
  };

  # Programs mesh-llm runs to detect GPUs: rocm-smi reports the AMD GPUs and their VRAM.
  # nvidia-smi comes with the NVIDIA driver instead.
  runtimePrograms = lib.optionals rocmSupport [ rocmPackages.rocm-smi ];
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mesh-llm";

  __structuredAttrs = true;
  strictDeps = true;
  # The runtime is built from the same MeshLLM release.
  inherit (skippy-native-runtime) version;
  src = skippy-native-runtime.meshLlmSrc;

  inherit (skippy-native-runtime) cargoHash;
  cargoBuildFlags = [
    "--package"
    "mesh-llm"
  ];
  # The tests of every crate, not only mesh-llm's, in the dev profile as
  # upstream's CI runs them: the release profile links every test binary with
  # LTO and one codegen unit, which needs more memory than a builder may have.
  checkType = "debug";
  cargoTestFlags = [
    "--workspace"
    # The release automation tool: its tests need git, curl, Swift and network
    # (see skippy-native-runtime's passthru.automation).
    "--exclude"
    "xtask"
  ];
  checkFlags = map (test: "--skip=${test}") (
    [
      # Runtime discovery tests that find the bundle preCheck points to:
      # https://github.com/Mesh-LLM/mesh-llm/issues/2630.
      "discovery::tests::local_runtime_listing_prefers_bundle_and_includes_distinct_cache_entries"
      "discovery::tests::local_runtime_listing_skips_malformed_bundle_and_cache_candidates"
      "tests::adjacent_windows_cpu_bundle_does_not_hide_a_remote_cuda_candidate"
      "tests::a_runtime_reached_through_two_bundle_directories_is_counted_as_a_bundle_duplicate"
      "tests::a_runtime_that_is_both_bundled_and_published_is_listed_once_and_served_from_the_bundle"
      "tests::bundle_artifacts_are_merged_with_the_release_manifest"
      "tests::bundle_only_load_takes_release_identity_from_the_bundle"
      "tests::default_manifest_url_is_skipped_when_not_allowed"
      "tests::default_manifest_url_is_still_consulted_when_bundle_dirs_exist"
      "tests::env_manifest_url_wins_over_default"
      "tests::explicit_gpu_selection_failure_names_the_catalogs_and_the_rejected_candidates"
      "tests::explicit_manifest_url_wins_over_env_and_default"
      "tests::installer_loads_published_v078_catalog_without_a_bundle"
      "tests::load_release_manifest_prefers_explicit_path_over_env_and_default"
      "tests::non_default_release_version_request_uses_versioned_release_url"
      "tests::recommended_selection_sets_aside_other_platforms_instead_of_listing_them"
      "tests::remote_fetch_failure_falls_back_to_bundles"
      "tests::remote_fetch_failure_without_bundles_is_an_error"
      "current_install_rejects_stale_catalog_instead_of_returning_cached_runtime"
      "current_install_uses_matching_bundle_despite_stale_catalog_and_cache"
      "runtime_native::tests::available_runtime_bundle_dirs_expand_a_product_root"
      "runtime_native::tests::doctor_discovery_includes_a_bundle_when_the_cache_is_empty"
      "system::native_runtime::dynamic::tests::cache_hit_skips_install_and_loads_cached_runtime_once"
      "system::native_runtime::dynamic::tests::cache_miss_installs_once_and_loads_post_install_runtime"
      "system::native_runtime::dynamic::tests::startup_local_discovery_keeps_cached_fallback_after_legacy_bundle"
      "system::native_runtime::dynamic::tests::vulkan_flavor_loads_vulkan_runtime_over_higher_ranked_cuda"
      # Runs /usr/bin/true as its artifact hook, which isn't in the sandbox:
      # https://github.com/Mesh-LLM/mesh-llm/pull/2699.
      "package_v2::tests::successful_artifact_hook_may_leave_verified_copies_for_rechecking"
      # Runs the skippy-package-builder binary, which never loads the runtime:
      # upstream builds and tests it statically, but the workspace-wide test run
      # gives it the dynamic one (noted on
      # https://github.com/Mesh-LLM/mesh-llm/pull/2629). This package doesn't
      # install it.
      "inspect_local_gguf_does_not_prepare_download_caches"
      # Gives shutdown 3 s, which a busy builder can miss:
      # https://github.com/Mesh-LLM/mesh-llm/issues/2700.
      "stage_control_shutdown_cancels_and_joins_an_active_readiness_probe"
      # Gives a single join attempt 5 s, which a busy builder can miss:
      # https://github.com/Mesh-LLM/mesh-llm/issues/2723.
      "mesh::tests::memberships::a_membership_admits_only_its_own_allowlist"
      # Runs a script it has just written, which fails with "Text file busy"
      # while another test thread forks:
      # https://github.com/Mesh-LLM/mesh-llm/issues/2716.
      "autoupdate::release_fetch::tests::test_staged_binary_version_must_match_release"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # Counts the machine's threads with sysctl, which isn't on PATH in the
      # sandbox: https://github.com/Mesh-LLM/mesh-llm/pull/2672.
      "runtime_100_create_drop_no_thread_leak"
      # Read process names and start times with ps, which isn't on PATH in the
      # sandbox: https://github.com/Mesh-LLM/mesh-llm/pull/2673.
      "process::pid_identity_tests::"
      "runtime::instance::scan_tests::scan_skips_dead_owners"
      "runtime::instance::tests::validate_"
      # Find the bundle preCheck points to, as the runtime discovery tests above.
      "system::native_runtime::dynamic::tests::startup_bundle_with_newer_glibc_does_not_block_compatible_cache"
      "system::native_runtime::dynamic::tests::startup_does_not_pass_legacy_linux_bundle_to_installer"
      # Deadlines of a few tens of milliseconds that a busy builder misses:
      # https://github.com/Mesh-LLM/mesh-llm/issues/2670.
      "plugin_dispatch::tests::blocking_commit_cannot_extend_the_proposal_deadline"
      "plugin_dispatch::tests::slow_commit_abstains_before_plugin_dispatch_and_later_positions_recover"
      "plugin_dispatch::tests::slow_passive_discard_cannot_run_the_next_proposal_after_its_deadline"
      "plugin_dispatch::tests::worker_reports_pre_dispatch_deadlines_without_running_the_callback"
    ]
  );

  # The web console, embedded into the binary by the default web-ui feature.
  pnpmRoot = "mesh/crates/mesh-llm-ui";
  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    sourceRoot = "${finalAttrs.src.name}/${finalAttrs.pnpmRoot}";
    # The console's package.json pins pnpm 10 (`packageManager`).
    pnpm = pnpm_10;
    fetcherVersion = 4;
    hash = "sha256-ZnBIXTOaG++AE6br+ZQqtDo1FSgUrzbti5Z5O/fh7D0=";
  };

  nativeBuildInputs = [
    cmake
    makeBinaryWrapper
    nodejs
    pnpm_10
    pnpmConfigHook
    pkg-config
  ];

  # Some tests start servers on 127.0.0.1.
  __darwinAllowLocalNetworking = true;
  # On Darwin, iroh's interface detection reaches CoreFoundation APIs that read
  # ICU data from the system and segfault without it (as for client-ready
  # below, and dumbpipe); the tests start iroh endpoints.
  sandboxProfile = ''
    (allow file-read* (subpath "/usr/share/icu"))
  '';

  # curl and python3 run the QA harnesses in scripts/. The analytics tests need a
  # CA bundle: their HTTP client can't be built without roots. So do the
  # scan_refresh tests in owned_node_commands_cli until
  # https://github.com/Mesh-LLM/mesh-llm/pull/2577 is in a release.
  nativeCheckInputs = [
    cacert
    curl
    python3
  ];

  preCheck = ''
    patchShebangs scripts
    # Without debug info: the workspace's test binaries are large, and linking
    # several of them in parallel with it exhausts the builder's memory.
    export CARGO_PROFILE_DEV_DEBUG=0
    # The tests that load the runtime find it here, and skippy-quantize's tests
    # read the quantization table of the pinned llama.cpp from .deps/llama.cpp.
    export MESH_LLM_NATIVE_RUNTIME_BUNDLE_DIR=${skippy-native-runtime}/share/mesh-llm/runtimes
    mkdir -p .deps
    ln -s ${skippy-native-runtime.src} .deps/llama.cpp
  '';

  postPatch = ''
    # Upstream's cargo config routes builds through sccache and its own linker drivers.
    rm .cargo/config.toml
  '';

  env = {
    # aws-lc-sys: its CMake builder, as nixpkgs' default crate overrides use.
    AWS_LC_SYS_CMAKE_BUILDER = 1;
    # nixpkgs' protoc instead of the prebuilt one from protoc-bin-vendored.
    PROTOC = lib.getExe' buildPackages.protobuf "protoc";
  };

  # cmake is only used by dependency build scripts
  dontUseCmakeConfigure = true;

  preBuild = ''
    pnpm --dir ${finalAttrs.pnpmRoot} build
  '';

  postInstall = ''
    wrapProgram $out/bin/mesh-llm ${
      lib.escapeShellArgs (
        lib.concatLists (
          lib.mapAttrsToList
            (name: value: [
              "--set-default"
              name
              value
            ])
            (
              runtimeEnvironment
              // {
                # nixpkgs updates mesh-llm, so it doesn't look for newer releases itself;
                # MESH_LLM_NO_UPDATE_CHECK=0 turns the checks back on.
                MESH_LLM_NO_UPDATE_CHECK = "1";
              }
            )
        )
        ++ lib.optionals (runtimePrograms != [ ]) [
          "--prefix"
          "PATH"
          ":"
          (lib.makeBinPath runtimePrograms)
        ]
      )
    }
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  # An unstable version reports only its release.
  preVersionCheck = "version=${lib.head (lib.splitString "-" finalAttrs.version)}";

  passthru = {
    # The bundles, their environment and the programs mesh-llm runs, for programs
    # that embed mesh-llm.
    inherit runtimes runtimeEnvironment runtimePrograms;
    # Also updates skippy-native-runtime, which pins the release.
    updateScript = ./update.sh;
    tests = {
      # Upstream's package QA (Mesh-LLM/mesh-packaging): a client reaches
      # readiness offline and stops cleanly on SIGINT.
      client-ready =
        runCommand "mesh-llm-client-ready"
          {
            nativeBuildInputs = [ finalAttrs.finalPackage ];
            # The client binds its mesh and console ports on localhost.
            __darwinAllowLocalNetworking = true;
            # On Darwin, iroh's interface detection reaches CoreFoundation APIs that
            # read ICU data from the system and segfault without it, as for dumbpipe.
            sandboxProfile = ''
              (allow file-read* (subpath "/usr/share/icu"))
            '';
          }
          ''
            export HOME=$TMPDIR/home XDG_CACHE_HOME=$TMPDIR/cache XDG_CONFIG_HOME=$TMPDIR/config
            export XDG_STATE_HOME=$TMPDIR/state MESH_LLM_NATIVE_RUNTIME_CACHE_DIR=$TMPDIR/runtimes
            mesh-llm --log-format json --port 19337 --console 13131 --no-console client > client.jsonl 2>&1 &
            pid=$!
            ready() {
              grep -q '"Client ready"' client.jsonl \
                || grep '"event": *"passive_mode"' client.jsonl | grep '"status": *"ready"' | grep -q '"role": *"client"'
            }
            for _ in $(seq 450); do
              ready && break
              kill -0 $pid || { cat client.jsonl; echo "client exited before readiness" >&2; exit 1; }
              sleep 0.1
            done
            ready || { cat client.jsonl; echo "client not ready after 45s" >&2; exit 1; }
            kill -INT $pid
            timeout 30 tail --pid=$pid -f /dev/null || { echo "client did not stop after SIGINT" >&2; exit 1; }
            wait $pid
            touch $out
          '';
    }
    // lib.optionalAttrs stdenv.hostPlatform.isLinux {
      # Serves a model with the bundled runtimes, offline, and completes a prompt
      # (the NixOS test does this on x86_64 Linux only). Linux only: Metal can't
      # run in the darwin sandbox, and without it mesh-llm on macOS budgets no
      # memory for a CPU-only model (https://github.com/Mesh-LLM/mesh-llm/issues/2671).
      serve =
        runCommand "mesh-llm-serve"
          {
            nativeBuildInputs = [
              finalAttrs.finalPackage
              curl
              jq
            ];
            # The 1 MB model of the NixOS test.
            model = fetchurl {
              url = "https://huggingface.co/ggml-org/models-moved/resolve/499bc8821c6b12b4e53c5bffcb21ec206f212d81/tinyllamas/stories260K.gguf";
              hash = "sha256-Jwy6G9UQn0LQM1D2BAYCRWBGTbFzwOOH2R8EJtO9JW0=";
            };
          }
          ''
            export HOME=$TMPDIR/home XDG_CACHE_HOME=$TMPDIR/cache XDG_CONFIG_HOME=$TMPDIR/config
            export XDG_STATE_HOME=$TMPDIR/state MESH_LLM_RUNTIME_ROOT=$TMPDIR/runtime
            mkdir -p $HOME/.mesh-llm
            printf 'version = 1\n\n[[models]]\nmodel = "%s"\n' "$model" > $HOME/.mesh-llm/config.toml
            mesh-llm serve --log-format json --port 19337 --console 13131 --bind-port 17842 > serve.jsonl 2>&1 &
            pid=$!
            trap '[ -e $out ] || cat serve.jsonl' EXIT
            for i in $(seq 360); do
              curl -fsS http://127.0.0.1:19337/v1/models 2>/dev/null | grep -q '"id"' && break
              kill -0 $pid || { echo "mesh-llm exited before serving" >&2; exit 1; }
              [ $i -lt 360 ] || { echo "mesh-llm listed no model within 3 minutes" >&2; exit 1; }
              sleep 0.5
            done
            id=$(curl -fsS http://127.0.0.1:19337/v1/models | jq -r '.data[0].id')
            curl -fsS http://127.0.0.1:19337/v1/completions -H 'Content-Type: application/json' \
              -d "{\"model\": \"$id\", \"prompt\": \"Once upon a time\", \"max_tokens\": 8}" \
              | jq -e '.choices[0].text | length > 0'
            kill -INT $pid
            timeout 30 tail --pid=$pid -f /dev/null || { echo "mesh-llm did not stop after SIGINT" >&2; exit 1; }
            touch $out
          '';
      # The GPU runtimes build without a GPU; building them catches packaging breakage
      # in backends that can't run here. One ROCm target is enough for that.
      runtime-rocm = runtime {
        rocmSupport = true;
        rocmGpuTargets = [ "gfx1100" ];
      };
    }
    // lib.optionalAttrs (stdenv.hostPlatform.isLinux && config.allowUnfree) {
      runtime-cuda = runtime { cudaSupport = true; };
    };
  };

  meta = {
    description = "Pool spare GPU capacity to run LLMs at larger scale";
    longDescription = ''
      MeshLLM pools the GPUs of several machines to serve large language
      models through an OpenAI-compatible API and a web console. This package
      bundles a CPU runtime and, on Linux, a Vulkan runtime. CUDA and ROCm
      runtimes come with `mesh-llm-cuda` (unfree) and `mesh-llm-rocm`, or with
      the nixpkgs settings `cudaSupport` and `rocmSupport`.
    '';
    homepage = "https://github.com/Mesh-LLM/mesh-llm";
    inherit (skippy-native-runtime.meta) changelog;
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ kleinbem ];
    mainProgram = "mesh-llm";
    inherit (skippy-native-runtime.meta) platforms;
  };
})
