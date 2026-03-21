{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
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
  version = "1.0.68";
  src = fetchFromGitHub {
    name = "exo";
    owner = "exo-explore";
    repo = "exo";
    tag = "v${version}";
    hash = "sha256-ryaz68vXS/SjPxGsWxtUSlzZrLBxV1tbBmJVraZu3RI=";
  };

  python = python3.override {
    packageOverrides = _final: prev: {
      # https://github.com/exo-explore/exo/blob/ba611f9cd0e21d3e63e2327b18fbc888fd085269/pyproject.toml#L67
      mlx = prev.mlx.overridePythonAttrs (old: {
        version = "custom";

        src = fetchFromGitHub {
          owner = "rltakashige";
          repo = "mlx-jaccl-fix-small-recv";
          rev = "address-rdma-gpu-locks";
          hash = "sha256-GosFIWxIB48Egb1MqJrR3xhsUsQeWdRk5rV93USY6wQ=";
        };
        meta = old.meta // {
          changelog = "";
        };
      });
    };
  };
  python3Packages = python.pkgs;

  pyo3-bindings = python3Packages.buildPythonPackage (finalAttrs: {
    pname = "exo-pyo3-bindings";
    inherit version src;
    pyproject = true;

    buildAndTestSubdir = "rust/exo_pyo3_bindings";

    cargoDeps = rustPlatform.fetchCargoVendor {
      inherit (finalAttrs) pname src version;
      hash = "sha256-Ga3/Yhg2Wn2w8cnNtq11/AN7K4nht4chSEIVOkYEI/U=";
    };

    # Bypass rust nightly features not being available on rust stable
    env.RUSTC_BOOTSTRAP = 1;

    nativeBuildInputs = [
      rustPlatform.cargoSetupHook
      rustPlatform.maturinBuildHook
    ];

    # The only test is failing
    doCheck = false;
  });

  dashboard = buildNpmPackage (finalAttrs: {
    pname = "exo-dashboard";
    inherit src version;

    sourceRoot = "${finalAttrs.src.name}/dashboard";
    npmDepsFetcherVersion = 3;

    npmDeps = fetchNpmDeps {
      inherit (finalAttrs)
        pname
        version
        src
        sourceRoot
        ;
      fetcherVersion = 3;
      hash = "sha256-eMmzWwsebwvrpNLqs+4iyiPsDFvwRlk+LaiKQ0SZmt8=";
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
      mlx-lm
      msgspec
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
      zstandard
    ]
    ++ sqlalchemy.optional-dependencies.asyncio;

  # 'resources' are not getting copied to the installation directory, so we do it manually
  # FileNotFoundError: Unable to locate resources. Did you clone the repo properly?
  postInstall = ''
    cp -r resources $out/${python.sitePackages}/exo/
  '';

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

  disabledTests = [
    # AttributeError: type object 'builtins.Keypair' has no attribute 'generate_ed25519'
    "test_sleep_on_multiple_items"

    # Require internet access:
    # openai_harmony.HarmonyError: error downloading or loading vocab file: failed to download or load vocab file
    "test_both_formats_produce_identical_tool_calls"
    "test_format_a_yields_tool_call"
    "test_format_b_yields_tool_call"
    "test_thinking_then_tool_call"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
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
