{
  lib,
  rustPlatform,
  cmake,
  curl,
  fetchurl,
  jq,
  makeBinaryWrapper,
  pkg-config,
  runCommand,
  versionCheckHook,
  mesh-llm,
  skippy-native-runtime,

  config,
  cudaSupport ? config.cudaSupport,
  rocmSupport ? config.rocmSupport,
}:

let
  # The same runtime bundles and environment as mesh-llm, which loads the same runtime.
  inherit (mesh-llm.override { inherit cudaSupport rocmSupport; })
    runtimeEnvironment
    runtimePrograms
    ;
in
# nixpkgs-update: no auto update
# mesh-llm's update script updates the release.
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "skippy";

  __structuredAttrs = true;
  strictDeps = true;
  # Skippy is released with MeshLLM, from the same source and tag.
  inherit (skippy-native-runtime) version;
  src = skippy-native-runtime.meshLlmSrc;
  inherit (mesh-llm) cargoDeps;

  cargoBuildFlags = [
    "--package"
    "skippy-cli"
    "--bin"
    "skippy"
  ];
  cargoTestFlags = [
    "--package"
    "skippy-cli"
  ];
  # Load the runtime from a bundle instead of linking llama.cpp statically.
  buildFeatures = [ "dynamic-native-runtime" ];

  nativeBuildInputs = [
    cmake
    makeBinaryWrapper
    pkg-config
  ];

  inherit (mesh-llm) postPatch env;

  # Some tests start servers on 127.0.0.1.
  __darwinAllowLocalNetworking = true;

  # cmake is only used by dependency build scripts
  dontUseCmakeConfigure = true;

  postInstall = ''
    wrapProgram $out/bin/skippy ${
      lib.escapeShellArgs (
        lib.concatLists (
          lib.mapAttrsToList (name: value: [
            "--set-default"
            name
            value
          ]) runtimeEnvironment
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
  inherit (mesh-llm) preVersionCheck;

  passthru.tests.serve =
    runCommand "skippy-serve"
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
        __darwinAllowLocalNetworking = true;
      }
      ''
        # Serves a model with the bundled runtime, offline.
        export HOME=$TMPDIR/home XDG_CACHE_HOME=$TMPDIR/cache
        # Metal can't create a command queue in the darwin sandbox; run on the
        # CPU, as llama-cpp's tests do.
        export GGML_METAL_DEVICES=0
        skippy serve --model "$model" --bind-addr 127.0.0.1:19337 > serve.log 2>&1 &
        pid=$!
        for _ in $(seq 240); do
          curl -fsS http://127.0.0.1:19337/v1/models 2>/dev/null | grep -q '"id"' && break
          kill -0 $pid || { cat serve.log; echo "skippy exited before serving" >&2; exit 1; }
          sleep 0.5
        done
        id=$(curl -fsS http://127.0.0.1:19337/v1/models | jq -r '.data[0].id')
        curl -fsS http://127.0.0.1:19337/v1/completions -H 'Content-Type: application/json' \
          -d "{\"model\": \"$id\", \"prompt\": \"Once upon a time\", \"max_tokens\": 8}" \
          | jq -e '.choices[0].text | length > 0'
        kill -INT $pid
        wait $pid || true
        touch $out
      '';

  meta = {
    description = "Serve a language model locally behind OpenAI- and Anthropic-compatible APIs";
    longDescription = ''
      Skippy is the model-serving engine of MeshLLM, usable on its own: it
      downloads models, sizes the context to the available memory and serves
      one model on this machine. This package bundles the same runtimes as
      mesh-llm (CPU and, on Linux, Vulkan; CUDA and ROCm with the nixpkgs
      settings `cudaSupport` and `rocmSupport`).
    '';
    homepage = "https://github.com/Mesh-LLM/mesh-llm/tree/main/skippy";
    inherit (skippy-native-runtime.meta) changelog;
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ kleinbem ];
    mainProgram = "skippy";
    inherit (skippy-native-runtime.meta) platforms;
  };
})
