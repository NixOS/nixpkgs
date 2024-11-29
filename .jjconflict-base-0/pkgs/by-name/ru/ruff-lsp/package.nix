{
  lib,
  python3Packages,
  fetchFromGitHub,

  # tests
  versionCheckHook,

  # passthru
  nix-update-script,
}:

python3Packages.buildPythonApplication rec {
  pname = "ruff-lsp";
  version = "0.0.59";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "astral-sh";
    repo = "ruff-lsp";
    rev = "refs/tags/v${version}";
    hash = "sha256-fMw93EmwO0wbIcGMr7csXkMRzgyQJNQzgLDZQqNB8Zc=";
  };

  build-system = with python3Packages; [ hatchling ];

  dependencies = with python3Packages; [
    packaging
    pygls
    lsprotocol
    ruff
    typing-extensions
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    pytest-asyncio
    python-lsp-jsonrpc
    ruff.bin
    versionCheckHook
  ];
  versionCheckProgramArg = [ "--version" ];

  makeWrapperArgs = [
    # prefer ruff from user's PATH, that's usually desired behavior
    "--suffix PATH : ${lib.makeBinPath (with python3Packages; [ ruff ])}"
    # Unset ambient PYTHONPATH in the wrapper, so ruff-lsp only ever runs with
    # its own, isolated set of dependencies. This works because the correct
    # PYTHONPATH is set in the Python script, which runs after the wrapper.
    "--unset PYTHONPATH"
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    changelog = "https://github.com/astral-sh/ruff-lsp/releases/tag/v${version}";
    description = "Language Server Protocol implementation for Ruff";
    homepage = "https://github.com/astral-sh/ruff-lsp";
    license = lib.licenses.mit;
    mainProgram = "ruff-lsp";
    maintainers = with lib.maintainers; [
      figsoda
      kalekseev
    ];
  };
}
