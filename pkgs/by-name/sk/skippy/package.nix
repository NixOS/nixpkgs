{
  lib,
  rustPlatform,
  aws-lc,
  curl,
  fetchurl,
  jq,
  makeBinaryWrapper,
  pkg-config,
  runCommand,
  versionCheckHook,
  mesh-llm,

  config,
  cudaSupport ? config.cudaSupport && !vulkanSupport,
  rocmSupport ? config.rocmSupport && !vulkanSupport,
  vulkanSupport ? false,
  rocmGpuTargets ? null,
}:

let
  # The same source, runtime bundle and environment as mesh-llm, which loads
  # the same runtime.
  meshLlm = mesh-llm.override (
    {
      inherit cudaSupport rocmSupport vulkanSupport;
    }
    // lib.optionalAttrs (rocmGpuTargets != null) { inherit rocmGpuTargets; }
  );
  inherit (meshLlm) runtimeEnvironment runtimePrograms;
in
# nixpkgs-update: no auto update
# mesh-llm's update script updates the release.
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "skippy";

  __structuredAttrs = true;
  strictDeps = true;
  # Skippy is released with MeshLLM, from the same source and tag.
  inherit (meshLlm) version src cargoDeps;

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
    makeBinaryWrapper
    pkg-config
  ];

  # Found through pkg-config by aws-lc-sys.
  buildInputs = [ aws-lc ];

  # Drops upstream's sccache cargo config and uses nixpkgs' protoc.
  inherit (meshLlm) postPatch env;

  # Some tests start servers on 127.0.0.1.
  __darwinAllowLocalNetworking = true;

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

  passthru.tests = lib.optionalAttrs (!cudaSupport && !rocmSupport && !vulkanSupport) {
    # Serves a model with the bundled runtime, offline, and completes a prompt.
    # GPU runtimes on Linux require a matching device at startup.
    serve =
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
          export HOME=$TMPDIR/home XDG_CACHE_HOME=$TMPDIR/cache
          # Metal can't create a command queue in the Darwin sandbox; run on the
          # CPU, as llama-cpp's tests do.
          export GGML_METAL_DEVICES=0
          skippy serve --model "$model" --bind-addr 127.0.0.1:19337 > serve.log 2>&1 &
          pid=$!
          trap '[ -e $out ] || cat serve.log' EXIT
          for i in $(seq 240); do
            curl -fsS http://127.0.0.1:19337/v1/models 2>/dev/null | grep -q '"id"' && break
            kill -0 $pid || { echo "skippy exited before serving" >&2; exit 1; }
            [ $i -lt 240 ] || { echo "skippy listed no model within 2 minutes" >&2; exit 1; }
            sleep 0.5
          done
          id=$(curl -fsS http://127.0.0.1:19337/v1/models | jq -r '.data[0].id')
          curl -fsS http://127.0.0.1:19337/v1/completions -H 'Content-Type: application/json' \
            -d "{\"model\": \"$id\", \"prompt\": \"Once upon a time\", \"max_tokens\": 8}" \
            | jq -e '.choices[0].text | length > 0'
          kill -INT $pid
          timeout 30 tail --pid=$pid -f /dev/null || { echo "skippy did not stop after SIGINT" >&2; exit 1; }
          touch $out
        '';
  };

  meta = {
    description = "Serve a language model locally behind OpenAI- and Anthropic-compatible APIs";
    longDescription = ''
      Skippy is the model-serving engine of MeshLLM, usable on its own: it
      downloads models, sizes the context to the available memory and serves
      one model on this machine. By default it bundles the Metal runtime on
      macOS and the CPU runtime on Linux; GPU backends on Linux are enabled
      with the nixpkgs settings `cudaSupport` (unfree) or `rocmSupport`
      (`rocmGpuTargets` limits the AMD GPUs built for), or by overriding
      `vulkanSupport = true`.
    '';
    homepage = "https://github.com/Mesh-LLM/mesh-llm/tree/main/skippy";
    inherit (meshLlm.meta) changelog;
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ kleinbem ];
    mainProgram = "skippy";
    inherit (meshLlm.meta) platforms badPlatforms;
  };
})
