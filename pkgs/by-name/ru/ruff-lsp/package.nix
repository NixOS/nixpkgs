{
  lib,
  python3,
  fetchFromGitHub,
  stdenv,
  ruff,
  nix-update-script,
  testers,
  ruff-lsp,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "ruff-lsp";
  version = "0.0.55";
  pyproject = true;
  disabled = python3.pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "astral-sh";
    repo = "ruff-lsp";
    rev = "refs/tags/v${version}";
    hash = "sha256-FFIZ8fDAPK03tnkjd2AUrz7iL8S9FziJQJKOxAisu48=";
  };

  postPatch = ''
    # ruff binary added to PATH in wrapper so it's not needed
    sed -i '/"ruff>=/d' pyproject.toml
  '';

  build-system = with python3.pkgs; [ hatchling ];

  dependencies = with python3.pkgs; [
    packaging
    pygls
    lsprotocol
    typing-extensions
  ];

  # fails in linux sandbox
  doCheck = stdenv.isDarwin;

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
    pytest-asyncio
    python-lsp-jsonrpc
    ruff
  ];

  makeWrapperArgs = [
    # prefer ruff from user's PATH, that's usually desired behavior
    "--suffix PATH : ${lib.makeBinPath [ ruff ]}"

    # Unset ambient PYTHONPATH in the wrapper, so ruff-lsp only ever runs with
    # its own, isolated set of dependencies. This works because the correct
    # PYTHONPATH is set in the Python script, which runs after the wrapper.
    "--unset PYTHONPATH"
  ];

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion { package = ruff-lsp; };
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
