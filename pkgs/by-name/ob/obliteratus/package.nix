{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "obliteratus";
  version = "0.1.3";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "elder-plinius";
    repo = "OBLITERATUS";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+HjRn5DvTrG1eBv3oDP8KTwFIbAqnXhBp6tzH4qyWng=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools==80.9.0" "setuptools" \
      --replace-fail "wheel==0.45.1" "wheel"
  '';

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    accelerate
    bitsandbytes
    datasets
    matplotlib
    numpy
    pandas
    pyyaml
    rich
    safetensors
    scikit-learn
    seaborn
    torch
    tqdm
    transformers
  ];

  optional-dependencies = with python3Packages; {
    spaces = [ gradio ];
  };

  pythonImportsCheck = [ "obliteratus" ];

  nativeCheckInputs = with python3Packages; [
    gradio
    hypothesis
    pytest-cov-stub
    pytestCheckHook
  ];

  disabledTestPaths = [
    # These tests reference `obliteratus.models.loader._select_model_class`, which upstream
    # removed/renamed without updating the tests or the benchmark script.
    "tests/test_gemma4_hard_tier_bench.py"
    "tests/test_gemma4_support.py"
  ];

  disabledTests = [
    # Upstream tests that hardcode expectations the implementation has since outgrown
    # (e.g. 512 prompts vs the current 842, a stale method set, changed pipeline defaults).
    "test_default_values"
    "test_informed_method_in_abliterate_methods"
    "test_informed_method_standalone"
    "test_inherits_base_pipeline"
    "test_linear_cone_fewer_directions"
    "test_methods_exist"
    "test_prompt_count_512"
    # Calls CLI
    "test_installed_package_cli_executes_offline_checkpoint_to_report_slice"
    "test_installed_wheel_cli_loads_local_model_without_repository_imports"
    # Tests require network access
    "test_pinned_mistral4_config_resolves_composite_contract_without_remote_code"
    "test_pinned_tiny_model_download_inference_and_offline_cache"
    "test_pinned_tiny_model_evaluator_produces_finite_perplexity"
    # Tests are hardware-dependent
    "test_jetson_cuda_runtime_contract"
    "test_jetson_cuda_offloaded_surgery_contract"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
    # aarch64-linux fails cpuinfo test, because /sys/devices/system/cpu/ does not exist in the sandbox:
    # RuntimeError: Failed to initialize cpuinfo!
    "test_output_dtype_preserved"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Ablation Suite for HuggingFace transformers";
    homepage = "https://github.com/elder-plinius/OBLITERATUS";
    changelog = "https://github.com/elder-plinius/OBLITERATUS/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "obliteratus";
  };
})
