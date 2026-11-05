{
  lib,
  rustPlatform,
  aws-lc,
  pkg-config,
  cacert,
  fetchurl,
  jq,
  runCommand,
  mesh-llm,
  skippy,
  skippy-native-runtime,
}:

# nixpkgs-update: no auto update
# mesh-llm's update script updates the release.
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "skippy-tools";

  __structuredAttrs = true;
  strictDeps = true;
  # Some tests start servers on 127.0.0.1.
  __darwinAllowLocalNetworking = true;
  inherit (skippy-native-runtime) version;
  src = skippy-native-runtime.meshLlmSrc;
  inherit (mesh-llm) cargoDeps;

  postPatch = (mesh-llm.postPatch or "") + ''
    # Both tools default to binaries in upstream's target/ directory: the stage
    # server is skippy's, and skippy-package-builder is installed next to skippy-quantize.
    # https://github.com/Mesh-LLM/mesh-llm/issues/3025
    substituteInPlace skippy/crates/skippy-correctness/src/cli.rs \
      --replace-fail '"target/debug/skippy"' '"${lib.getExe skippy}"'
    substituteInPlace skippy/crates/skippy-quantize/src/main.rs \
      --replace-fail '"target/release/skippy-package-builder"' "\"$out/bin/skippy-package-builder\""
  '';

  # As upstream's skippy-quantize-standalone-build (just/skippy.just): link the
  # runtime's llama.cpp instead of loading it at run time. Cargo unifies features
  # across the four packages, so skippy-quantize's default would switch all of them.
  buildNoDefaultFeatures = true;
  checkNoDefaultFeatures = true;

  cargoBuildFlags = [
    "--package"
    "skippy-package-builder"
    "--package"
    "skippy-quantize"
    "--package"
    "llama-spec-bench"
    "--package"
    "skippy-correctness"
  ];

  cargoTestFlags = finalAttrs.cargoBuildFlags;

  nativeBuildInputs = [
    pkg-config
  ];

  # skippy-correctness's cache tests build an HTTP client, which can't be built
  # without CA roots (https://github.com/Mesh-LLM/mesh-llm/issues/2740).
  nativeCheckInputs = [ cacert ];

  buildInputs = [
    # Found through pkg-config by aws-lc-sys.
    aws-lc
    skippy-native-runtime
  ];

  # mesh-llm's postPatch and env (nixpkgs' protoc, no sccache cargo config) apply
  # to the same source. The tools link skippy-native-runtime, which follows
  # config.cudaSupport and config.rocmSupport.
  env = (mesh-llm.env or { }) // {
    SKIPPY_LLAMA_LINK_MODE = "dynamic";
    SKIPPY_LLAMA_LIB_DIR = "${skippy-native-runtime}/lib";
  };

  # skippy-quantize's tests read the quantization table of the pinned llama.cpp
  # from .deps/llama.cpp.
  preCheck = ''
    mkdir -p .deps
    ln -s ${skippy-native-runtime.src} .deps/llama.cpp
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    for bin in skippy-package-builder skippy-quantize llama-spec-bench skippy-correctness; do
      echo "checking $bin --help"
      "$out/bin/$bin" --help > /dev/null
    done
    runHook postInstallCheck
  '';

  passthru.tests = {
    model-tools =
      runCommand "skippy-tools-model-test"
        {
          __darwinAllowLocalNetworking = true;
          nativeBuildInputs = [
            finalAttrs.finalPackage
            jq
          ];
          model = fetchurl {
            url = "https://huggingface.co/ggml-org/models-moved/resolve/499bc8821c6b12b4e53c5bffcb21ec206f212d81/tinyllamas/stories260K.gguf";
            hash = "sha256-Jwy6G9UQn0LQM1D2BAYCRWBGTbFzwOOH2R8EJtO9JW0=";
          };
        }
        ''
          export HOME=$TMPDIR/home
          # Metal can't create a command queue in the darwin sandbox; run on the
          # CPU, as skippy's serve test does.
          export GGML_METAL_DEVICES=0
          skippy-package-builder inspect "$model" | jq -e '.tensor_count == 48'
          mkdir "$TMPDIR/out"
          skippy-quantize quantize "$model" "$TMPDIR/out/q8.gguf" Q8_0 --work-dir "$TMPDIR/work"
          # The result is written as a split model with one shard.
          shards=("$TMPDIR"/out/*.gguf)
          [ ''${#shards[@]} -eq 1 ]
          skippy-package-builder inspect "''${shards[0]}" | jq -e '.tensor_count == 48'
          # Splits the 5-layer model after layer 2 and runs the second half in a
          # skippy stage server; checks the result against the unsplit model.
          skippy-correctness single-step --model "$model" --model-id ggml-org/models:stories260K \
            --split-layer 2 --layer-end 5
          touch $out
        '';
  };

  meta = {
    description = "Model management, benchmarking, and quantization tools for Skippy and MeshLLM";
    longDescription = ''
      Operator and diagnostic tooling for Skippy model serving:
      - skippy-package-builder: inspects models and authors/verifies Skippy package manifests
      - skippy-quantize: converts and quantizes GGUF models
      - llama-spec-bench: checks speculative-decoding draft/target model pairs
      - skippy-correctness: validates split-layer distributed inference against monolithic execution
    '';
    homepage = "https://github.com/Mesh-LLM/mesh-llm/tree/main/skippy";
    inherit (skippy-native-runtime.meta) changelog;
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ kleinbem ];
    inherit (skippy-native-runtime.meta) platforms;
  };
})
