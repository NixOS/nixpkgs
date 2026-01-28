{
  lib,
  stdenv,
  fetchFromGitHub,
  python3Packages,
  replaceVars,
  macmon,

  # pyo3-bindings
  rustPlatform,

  # dashboard
  buildNpmPackage,
  fetchNpmDeps,

  writableTmpDirAsHomeHook,

  nix-update-script,
}:
let
  version = "1.0.67";
  src = fetchFromGitHub {
    name = "exo";
    owner = "exo-explore";
    repo = "exo";
    tag = "v${version}";
    hash = "sha256-hipCiAqCkkyrVcQXEZKbGoVbgjM3hykUcazNPEbT+q8=";
  };

  pyo3-bindings = python3Packages.buildPythonPackage (finalAttrs: {
    pname = "exo-pyo3-bindings";
    inherit version src;
    pyproject = true;

    buildAndTestSubdir = "rust/exo_pyo3_bindings";

    cargoDeps = rustPlatform.fetchCargoVendor {
      inherit (finalAttrs) pname src version;
      hash = "sha256-N7B1WFqPdqeNPZe9hXGyX7F3EbB1spzeKc19BFDDwls=";
    };

    # Bypass rust nightly features not being available on rust stable
    env.RUSTC_BOOTSTRAP = 1;

    nativeBuildInputs = [
      rustPlatform.cargoSetupHook
      rustPlatform.maturinBuildHook
    ];

    nativeCheckInputs = with python3Packages; [
      pytest-asyncio
      pytestCheckHook
    ];

    enabledTestPaths = [
      "rust/exo_pyo3_bindings/tests/"
    ];

    # RuntimeError
    # Attempted to create a NULL object
    doCheck = !stdenv.hostPlatform.isDarwin;
  });

  dashboard = buildNpmPackage (finalAttrs: {
    pname = "exo-dashboard";
    inherit src version;

    sourceRoot = "${finalAttrs.src.name}/dashboard";

    npmDeps = fetchNpmDeps {
      inherit (finalAttrs)
        pname
        version
        src
        sourceRoot
        ;
      fetcherVersion = 2;
      hash = "sha256-3ZgE1ysb1OeB4BNszvlrnYcc7gOo7coPfOEQmMHC6E0=";
    };
  });

  # exo requires building mlx-lm from its main branch to use the kimi-k2.5 model
  mlx-lm-unstable = python3Packages.mlx-lm.overridePythonAttrs (old: {
    version = "0.30.4-unstable-2026-01-27";
    src = old.src.override {
      rev = "96699e6dadb13b82b28285bb131a0741997d19ae";
      tag = null;
      hash = "sha256-L1ws8XA8VhR18pRuRGbVal/yEfJaFNW8QzS16C1dFpE=";
    };
    meta = old.meta // {
      changelog = "https://github.com/ml-explore/mlx-lm/releases/tag/v0.30.5";
    };
  });
in
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "exo";
  pyproject = true;

  inherit version src;

  patches = [
    (replaceVars ./inject-dashboard-path.patch {
      dashboard = "${dashboard}/lib/node_modules/${dashboard.pname}/build";
    })
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.8.9,<0.9.0" "uv_build"
  ''
  # MemoryObjectStreamState was renamed in
  # https://github.com/agronholm/anyio/pull/1009/changes/bdc945a826d0d5917aea3517ceb9fe335b468094
  + ''
    substituteInPlace src/exo/utils/channels.py \
      --replace-fail \
        "MemoryObjectStreamState as AnyioState," \
        "_MemoryObjectStreamState as AnyioState,"
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace src/exo/utils/info_gatherer/info_gatherer.py \
      --replace-fail \
        'shutil.which("macmon")' \
        '"${lib.getExe macmon}"'
  '';

  build-system = with python3Packages; [
    uv-build
  ];

  pythonRelaxDeps = true;

  pythonRemoveDeps = [
    "types-aiofiles"
    "uuid"
  ];
  dependencies =
    with python3Packages;
    [
      aiofiles
      aiohttp
      aiohttp-cors
      anyio
      fastapi
      filelock
      grpcio
      grpcio-tools
      httpx
      huggingface-hub
      hypercorn
      jinja2
      loguru
      mflux
      mlx
      mlx-lm-unstable
      nvidia-ml-py
      openai
      openai-harmony
      opencv-python
      pillow
      prometheus-client
      psutil
      pydantic
      pyo3-bindings
      python-multipart
      rustworkx
      scapy
      tiktoken
      tinygrad
      tomlkit
      transformers
      uvloop
    ]
    ++ sqlalchemy.optional-dependencies.asyncio;

  pythonImportsCheck = [
    "exo"
    "exo.main"
  ];

  nativeCheckInputs = [
    python3Packages.pytest-asyncio
    python3Packages.pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  # Otherwise fails with 'import file mismatch'
  preCheck = ''
    rm src/exo/__init__.py
  '';

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
    # AssertionError: assert "MacMon not found in PATH" in str(exc_info.value)
    "test_macmon_not_found_raises_macmon_error"

    # ValueError: zip() argument 2 is longer than argument 1
    "test_events_processed_in_correct_order"

    # system_profiler is not available in the sandbox
    "test_tb_parsing"

    # Flaky in the sandbox (even when __darwinAllowLocalNetworking is enabled)
    # RuntimeError - Attempted to create a NULL object.
    "test_sleep_on_multiple_items"

    # Flaky in the sandbox (even when __darwinAllowLocalNetworking is enabled)
    # AssertionError: Expected 2 results, got 0. Errors: {0: "[ring] Couldn't bind socket (error: 1)"}
    "test_composed_call_works"
  ];

  disabledTestPaths = [
    # All tests hang indefinitely
    "src/exo/worker/tests/unittests/test_mlx/test_tokenizers.py"
  ];

  passthru = {
    updateScript = nix-update-script { };
    exo-pyo3-bindings = pyo3-bindings;
    exo-dashboard = dashboard;
  };

  meta = {
    description = "Run your own AI cluster at home with everyday devices";
    homepage = "https://github.com/exo-explore/exo";
    changelog = "https://github.com/exo-explore/exo/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "exo";
  };
})
