{
  lib,
  python311,
  fetchFromGitHub,
  git,
  portaudio,
}:

let
  python3 = python311.override {
    self = python3;
    packageOverrides = _: super: { tree-sitter = super.tree-sitter_0_21; };
  };
in
python3.pkgs.buildPythonApplication rec {
  pname = "aider-chat";
  version = "0.48.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "paul-gauthier";
    repo = "aider";
    rev = "v${version}";
    hash = "sha256-0m5ZHCfxlOOeUvfQznF5hTCJANCBtrO9rWDudQ+RUxM=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  dependencies =
    with python3.pkgs;
    [
      aiohappyeyeballs
      backoff
      beautifulsoup4
      configargparse
      diff-match-patch
      diskcache
      flake8
      gitpython
      grep-ast
      importlib-resources
      jsonschema
      litellm
      networkx
      numpy
      packaging
      pathspec
      pillow
      playwright
      prompt-toolkit
      pypandoc
      pyyaml
      rich
      scipy
      sounddevice
      soundfile
      streamlit
      watchdog
    ]
    ++ lib.optionals (!tensorflow.meta.broken) [
      llama-index-core
      llama-index-embeddings-huggingface
    ];

  buildInputs = [ portaudio ];

  pythonRelaxDeps = true;

  nativeCheckInputs = (with python3.pkgs; [ pytestCheckHook ]) ++ [ git ];

  disabledTestPaths = [
    # requires network
    "tests/scrape/test_scrape.py"

    # Expected 'mock' to have been called once
    "tests/help/test_help.py"
  ];

  disabledTests = [
    # requires network
    "test_urls"
    "test_get_commit_message_with_custom_prompt"

    # FileNotFoundError
    "test_get_commit_message"

    # Expected 'launch_gui' to have been called once
    "test_browser_flag_imports_streamlit"
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  meta = {
    description = "AI pair programming in your terminal";
    homepage = "https://github.com/paul-gauthier/aider";
    license = lib.licenses.asl20;
    mainProgram = "aider";
    maintainers = with lib.maintainers; [ taha-yassine ];
  };
}
