{
  lib,
  python3Packages,
  fetchFromGitHub,
  nix-update-script,
}:
python3Packages.buildPythonApplication rec {
  pname = "claude-swap";
  version = "0.22.0";
  disabled = python3Packages.pythonOlder "3.12";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "realiti4";
    repo = "claude-swap";
    tag = "v${version}";
    hash = "sha256-jRiICzOXSiLRxM24NEj+RCqzcDgCsLtLEc6Ge+1UpPQ=";
  };

  build-system = with python3Packages; [
    hatchling
  ];

  dependencies = with python3Packages; [
    keyring
    textual
    truststore
  ];

  pythonImportsCheck = [ "claude_swap" ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    pytest-asyncio
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Switch between multiple Claude Code accounts, with automatic rate-limit rotation, usage dashboard, and parallel sessions";
    homepage = "https://github.com/realiti4/claude-swap";
    changelog = "https://github.com/realiti4/claude-swap/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "cswap";
    maintainers = [ lib.maintainers.abcsds ];
    platforms = lib.platforms.unix;
  };
}
