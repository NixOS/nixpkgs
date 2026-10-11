{
  lib,
  stdenv,
  rustPlatform,
  buildPackages,
  fetchPnpmDeps,
  cacert,
  fetchurl,
  jq,
  cmake,
  makeBinaryWrapper,
  nodejs,
  pnpm_10,
  pnpmConfigHook,
  pkg-config,
  python3,
  curl,
  versionCheckHook,
  mesh-llm-native-runtime,
  nixosTests,
  runCommand,

  config,
  cudaSupport ? config.cudaSupport,
  rocmSupport ? config.rocmSupport,
}:

let
  # mesh-llm loads llama.cpp from a native runtime bundle and picks the best one
  # for the machine. Ship the ones built from source so nothing is downloaded.
  runtime =
    args:
    mesh-llm-native-runtime.override (
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
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mesh-llm";

  __structuredAttrs = true;
  strictDeps = true;
  # The runtime is built from the same MeshLLM release.
  inherit (mesh-llm-native-runtime) version;
  src = mesh-llm-native-runtime.meshLlmSrc;

  cargoHash = "sha256-BMLcQnYgOSshqp+y16zomAUdsGX4bAPrv4iYYx96T3g=";
  cargoBuildFlags = [
    "--package"
    "mesh-llm"
  ];
  cargoTestFlags = finalAttrs.cargoBuildFlags;

  # The web console, embedded into the binary by the default web-ui feature.
  pnpmRoot = "crates/mesh-llm-ui";
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

  # Some CLI tests build an HTTPS client (CA bundle), and some run the QA
  # harnesses in scripts/ (python3, bash, curl).
  nativeCheckInputs = [
    cacert
    curl
    python3
  ];

  preCheck = ''
    patchShebangs scripts
  '';

  postPatch = ''
    # Upstream's cargo config routes builds through sccache and its own linker
    # drivers (mold/lld probing); build with the nixpkgs toolchain instead.
    sed -i -e '/^rustc-wrapper = "sccache"$/d' -e '/^linker = "scripts\/cargo-linker/d' .cargo/config.toml

    # Use nixpkgs' protoc instead of the prebuilt one from protoc-bin-vendored.
    substituteInPlace crates/{mesh-llm-plugin,skippy-protocol}/build.rs \
      --replace-fail 'protoc_bin_vendored::protoc_bin_path().expect("vendored protoc")' \
        'std::path::PathBuf::from(std::env::var("PROTOC").expect("PROTOC"))'
  '';

  env = {
    AWS_LC_SYS_CMAKE_BUILDER = 1;
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
          lib.mapAttrsToList (name: value: [
            "--set-default"
            name
            value
          ]) runtimeEnvironment
        )
      )
    }
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru = {
    # The bundles and their environment, for programs that embed mesh-llm
    # (buzz-desktop).
    inherit runtimes runtimeEnvironment;
    # Also updates mesh-llm-native-runtime, which pins the release.
    updateScript = ./update.sh;
    tests = {
      nixos = nixosTests.mesh-llm;
      # Upstream's package QA (Mesh-LLM/mesh-packaging): a client reaches
      # readiness offline and stops cleanly on SIGINT.
      client-ready =
        runCommand "mesh-llm-client-ready"
          {
            # The client builds an HTTPS client at startup, which loads the CA bundle.
            nativeBuildInputs = [
              finalAttrs.finalPackage
              cacert
            ];
            # In the macOS build sandbox mesh-llm crashes at startup; without the
            # sandbox the check passes there too.
            meta.platforms = lib.platforms.linux;
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
      # Offline: serve a tiny model with the bundled runtime (and no other one)
      # and complete a prompt through the OpenAI-compatible API.
      serve =
        runCommand "mesh-llm-serve"
          {
            nativeBuildInputs = [
              finalAttrs.finalPackage
              curl
              jq
            ];
            model = fetchurl {
              url = "https://huggingface.co/ggml-org/models-moved/resolve/499bc8821c6b12b4e53c5bffcb21ec206f212d81/tinyllamas/stories260K.gguf";
              hash = "sha256-Jwy6G9UQn0LQM1D2BAYCRWBGTbFzwOOH2R8EJtO9JW0=";
            };
            # On macOS mesh-llm sizes models by the Metal device, which the
            # build sandbox doesn't provide.
            meta.platforms = lib.platforms.linux;
          }
          ''
            export HOME=$TMPDIR
            mesh-llm runtime list | tee runtimes.txt
            grep -q -- '-nixpkgs ' runtimes.txt
            # --local-model-only takes an absolute path that isn't a symlink.
            cp $model model.gguf
            mesh-llm --log-format json serve --local-model-only --gguf $PWD/model.gguf --port 19337 > serve.jsonl 2>&1 &
            pid=$!
            for _ in $(seq 120); do
              curl -sf http://127.0.0.1:19337/v1/models > models.json && break
              kill -0 $pid || { cat serve.jsonl; exit 1; }
              sleep 1
            done
            curl -sf --max-time 60 http://127.0.0.1:19337/v1/completions -H 'Content-Type: application/json' \
              -d "$(jq -n --arg model "$(jq -r '.data[0].id' models.json)" '{$model, prompt: "Once upon a time", max_tokens: 8}')" \
              > completion.json || { cat serve.jsonl; exit 1; }
            jq -e '.choices[0].text | length > 0' completion.json
            kill $pid
            touch $out
          '';
    };
  };

  meta = {
    description = "Pool spare GPU capacity to run LLMs at larger scale";
    longDescription = ''
      MeshLLM pools the GPUs of several machines to serve large language
      models through an OpenAI-compatible API and a web console. This package
      bundles a CPU runtime and, on Linux, a Vulkan runtime. CUDA and ROCm
      runtimes are added with the nixpkgs settings `cudaSupport` and
      `rocmSupport`, or with `mesh-llm.override { cudaSupport = true; }`
      (CUDA is unfree). To run a node on NixOS, use `services.mesh-llm`.
    '';
    homepage = "https://github.com/Mesh-LLM/mesh-llm";
    changelog = "https://github.com/Mesh-LLM/mesh-llm/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ kleinbem ];
    mainProgram = "mesh-llm";
    inherit (mesh-llm-native-runtime.meta) platforms;
  };
})
