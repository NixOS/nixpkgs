{
  lib,
  stdenv,
  python3Packages,
  fetchFromGitHub,
  versionCheckHook,
  writableTmpDirAsHomeHook,
  ripgrep,
  bash,
}:

let
  version = "1.3";
  src = fetchFromGitHub {
    owner = "MoonshotAI";
    repo = "kimi-cli";
    rev = version;
    hash = "sha256-JfXJKyXX5G2ZLn3thx7vMXsE+1hCuoD2Mat6MNQ8cVI=";
  };
in
python3Packages.buildPythonApplication {
  pname = "kimi-cli";
  inherit version src;
  pyproject = true;

  build-system = [ python3Packages.uv-build ];
  pythonRelaxDeps = true;

  patches = [ ./test-run-kimi-cli-without-uv.patch ];

  dependencies = (
    with python3Packages;
    [
      kosong
      pykaos

      agent-client-protocol
      aiofiles
      aiohttp
      typer
      loguru
      prompt-toolkit
      pillow
      pyyaml
      rich
      ripgrepy
      streamingjson
      trafilatura
      lxml
      tenacity
      # fastmcp -> py-key-value-aio -> aioboto3 -> cfn-lint -> aws-sam-translator
      # aws-sam-translator-1.103.0 not supported for interpreter python3.14
      # This creates a dependency conflict with batrachian-toad
      fastmcp
      pydantic
      httpx
      # batrachian-toad package is required for the `kimi term` feature
      # but cannot be included due Python version incompatibility
      # batrachian-toad requires Python >= 3.14
      # fastmcp's dependency chain breaks with Python 3.14 (aws-sam-translator incompatibility)
      # batrachian-toad
      tomlkit
      jinja2
      keyring
    ]
    ++ (lib.optionals stdenv.hostPlatform.isDarwin [
      pyobjc-framework-Cocoa
    ])
  );

  postFixup = ''
    wrapProgram $out/bin/kimi \
      --prefix PATH : ${lib.makeBinPath [ ripgrep ]} \
      --set KIMI_CLI_NO_AUTO_UPDATE "1"

    wrapProgram $out/bin/kimi-cli \
      --prefix PATH : ${lib.makeBinPath [ ripgrep ]} \
      --set KIMI_CLI_NO_AUTO_UPDATE "1"
  '';

  preInstallCheck = ''
    substituteInPlace tests/conftest.py tests/core/test_default_agent.py tests/tools/test_tool_descriptions.py \
      --replace-fail "/bin/bash" "${lib.getExe bash}"

    substituteInPlace tests/e2e/test_basic_e2e.py tests/e2e/test_media_e2e.py tests_e2e/wire_helpers.py \
      --replace-fail "@KIMI_CLI@" "$out/bin/kimi-cli"
  '';

  disabledTests = [
    # somehow timeout
    "test_mcp_tool_call"
  ];
  disabledTestPaths = [
    # not this application
    "sdks/kimi-sdk/tests/"
    # network required
    "tests/tools/test_fetch_url.py"
    # no need to test pyinstaller
    # it requires the file '/nix/store/...-kimi-cli/lib/python3.13/site-packages/kimi_cli/tools/shell/bash.md'
    # to be located under the '/build/source'.
    "tests/utils/test_pyinstaller_utils.py"
  ];
  nativeInstallCheckInputs = [
    versionCheckHook

    writableTmpDirAsHomeHook
    python3Packages.pytestCheckHook
    python3Packages.inline-snapshot
    python3Packages.pytest-asyncio
    python3Packages.respx
    ripgrep
  ];
  pythonImportsCheck = [ "kimi_cli" ];

  meta = {
    description = "Your next CLI agent by MoonshotAI";
    homepage = "https://github.com/MoonshotAI/kimi-cli";
    changelog = "https://github.com/MoonshotAI/kimi-cli/blob/${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jinser ];
    mainProgram = "kimi";
  };
}
