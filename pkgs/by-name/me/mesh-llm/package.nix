{
  lib,
  stdenv,
  rustPlatform,
  buildPackages,
  fetchPnpmDeps,
  cacert,
  aws-lc,
  makeBinaryWrapper,
  nodejs,
  pnpm_10,
  pnpmConfigHook,
  pkg-config,
  python3,
  sqlite,
  curl,
  fetchurl,
  jq,
  versionCheckHook,
  skippy-native-runtime,
  rocmPackages,
  runCommand,

  config,
  cudaSupport ? config.cudaSupport && !vulkanSupport,
  rocmSupport ? config.rocmSupport && !vulkanSupport,
  vulkanSupport ? false,
  # The AMD GPUs the ROCm runtime is built for, as for skippy-native-runtime;
  # every target by default, which takes long to build.
  rocmGpuTargets ? rocmPackages.clr.localGpuTargets or rocmPackages.clr.gpuTargets,
}:

let
  # The llama.cpp runtime bundle mesh-llm loads, built here so nothing is downloaded.
  runtime = skippy-native-runtime.override {
    inherit
      cudaSupport
      rocmSupport
      vulkanSupport
      rocmGpuTargets
      ;
  };

  # Clears global GPU settings so each passthru build test enables only its own backend.
  testRuntime =
    args:
    skippy-native-runtime.override (
      {
        cudaSupport = false;
        rocmSupport = false;
        vulkanSupport = false;
      }
      // args
    );

  # Where mesh-llm finds the bundle, and what it needs it to know.
  runtimeEnvironment = runtime.hostEnvironment // {
    MESH_LLM_NATIVE_RUNTIME_BUNDLE_DIR = "${runtime}/share/mesh-llm/runtimes";
  };

  # Programs mesh-llm runs to detect GPUs: rocm-smi reports the AMD GPUs and their VRAM.
  # nvidia-smi comes with the NVIDIA driver instead.
  runtimePrograms = lib.optionals rocmSupport [ rocmPackages.rocm-smi ];
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mesh-llm";

  __structuredAttrs = true;
  strictDeps = true;
  # The runtime is built from the same MeshLLM release and shares its vendored crates.
  inherit (runtime) version;
  src = runtime.meshLlmSrc;

  inherit (runtime.automation) cargoDeps;
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
    # Upstream's CI process supervision, repository tooling like xtask: its
    # tests run /bin/sleep, which neither the sandbox nor NixOS has. Drop once
    # https://github.com/Mesh-LLM/mesh-llm/pull/2939 is in the release.
    "--exclude"
    "process-supervision"
  ];
  checkFlags = [
    # Runs the skippy-package-builder binary, which never loads the runtime:
    # upstream builds and tests it statically, but the workspace-wide test run
    # gives it the dynamic one
    # (https://github.com/Mesh-LLM/mesh-llm/issues/2740). This package doesn't
    # install it.
    "--skip=inspect_local_gguf_does_not_prepare_download_caches"
    # Pins llama_context_params' layout from before llama.cpp b12199, which grew
    # it by 8 bytes; https://github.com/Mesh-LLM/mesh-llm/pull/2962 updates it.
    "--skip=llama_draft::tests::mirrors_match_the_pinned_upstream_layouts"
    # Its 10 ms deadline can expire before the caller thread starts on a busy
    # builder; lengthened in https://github.com/Mesh-LLM/mesh-llm/pull/3018.
    "--skip=frontend::iteration_scheduler::tests::direct_iteration_rechecks_deadline_after_worker_reply"
  ];

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
    makeBinaryWrapper
    nodejs
    pnpm_10
    pnpmConfigHook
    pkg-config
  ];

  # Found through pkg-config by aws-lc-sys and rusqlite's libsqlite3-sys.
  buildInputs = [
    aws-lc
    sqlite
  ];

  # Some tests start servers on 127.0.0.1.
  __darwinAllowLocalNetworking = true;
  # On Darwin, iroh's interface detection reaches CoreFoundation APIs that read
  # ICU data from the system and segfault without it (as for client-ready
  # below, and dumbpipe); the tests start iroh endpoints. The ACL tests set and
  # read ACLs with the system's chmod and ls, independently of the code.
  sandboxProfile = ''
    (allow file-read* (subpath "/usr/share/icu"))
    (allow process-exec (literal "/bin/chmod") (literal "/bin/ls"))
  '';

  # curl and python3 run the QA harnesses in scripts/. The analytics tests need a
  # CA bundle: their HTTP client can't be built without roots
  # (https://github.com/Mesh-LLM/mesh-llm/issues/2740).
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
    export MESH_LLM_NATIVE_RUNTIME_BUNDLE_DIR=${runtime}/share/mesh-llm/runtimes
    mkdir -p .deps
    ln -s ${runtime.src} .deps/llama.cpp
  '';

  postPatch = ''
    # Upstream's cargo config routes builds through sccache and its own linker drivers.
    rm .cargo/config.toml
  '';

  env = {
    # nixpkgs' protoc instead of the prebuilt one from protoc-bin-vendored.
    PROTOC = lib.getExe' buildPackages.protobuf "protoc";
  };

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

  passthru = {
    # The bundle, its environment and the programs mesh-llm runs, for programs
    # that embed mesh-llm.
    inherit runtime runtimeEnvironment runtimePrograms;
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
    //
      lib.optionalAttrs (stdenv.hostPlatform.isLinux && !cudaSupport && !rocmSupport && !vulkanSupport)
        {
          # Serves a model with the CPU runtime, offline, and completes a prompt.
          # GPU runtimes require a matching device at startup, and in the Darwin
          # sandbox Metal reports a device without memory so no model loads.
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
                mesh-llm serve --log-format json --port 19347 --console 13141 --bind-port 17852 > serve.jsonl 2>&1 &
                pid=$!
                trap '[ -e $out ] || cat serve.jsonl' EXIT
                for i in $(seq 360); do
                  curl -fsS http://127.0.0.1:19347/v1/models 2>/dev/null | grep -q '"id"' && break
                  kill -0 $pid || { echo "mesh-llm exited before serving" >&2; exit 1; }
                  [ $i -lt 360 ] || { echo "mesh-llm listed no model within 3 minutes" >&2; exit 1; }
                  sleep 0.5
                done
                id=$(curl -fsS http://127.0.0.1:19347/v1/models | jq -r '.data[0].id')
                curl -fsS http://127.0.0.1:19347/v1/completions -H 'Content-Type: application/json' \
                  -d "{\"model\": \"$id\", \"prompt\": \"Once upon a time\", \"max_tokens\": 8}" \
                  | jq -e '.choices[0].text | length > 0'
                kill -INT $pid
                timeout 30 tail --pid=$pid -f /dev/null || { echo "mesh-llm did not stop after SIGINT" >&2; exit 1; }
                touch $out
              '';
        }
    // lib.optionalAttrs stdenv.hostPlatform.isLinux {
      # The GPU runtimes build without a GPU; building them catches packaging breakage
      # in backends that can't run here.
      runtime-vulkan = testRuntime { vulkanSupport = true; };
    }
    // lib.optionalAttrs (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isx86_64) {
      # nixpkgs' ROCm LLVM is x86_64-linux only; one target is enough for a build check.
      runtime-rocm = testRuntime {
        rocmSupport = true;
        rocmGpuTargets = [ "gfx1100" ];
      };
    }
    // lib.optionalAttrs (stdenv.hostPlatform.isLinux && config.allowUnfree) {
      runtime-cuda = testRuntime { cudaSupport = true; };
    };
  };

  meta = {
    description = "Pool spare GPU capacity to run LLMs at larger scale";
    longDescription = ''
      MeshLLM pools the GPUs of several machines to serve large language
      models through an OpenAI-compatible API and a web console. By default it
      bundles the Metal runtime on macOS and the CPU runtime on Linux; GPU
      backends on Linux are enabled with the nixpkgs settings `cudaSupport`
      (unfree) or `rocmSupport` (`rocmGpuTargets` limits the AMD GPUs built
      for), or by overriding `vulkanSupport = true`.
    '';
    homepage = "https://github.com/Mesh-LLM/mesh-llm";
    inherit (runtime.meta) changelog;
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ kleinbem ];
    mainProgram = "mesh-llm";
    inherit (runtime.meta) platforms badPlatforms;
  };
})
