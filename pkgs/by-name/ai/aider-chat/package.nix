{
  lib,
  stdenv,
  python311,
  fetchFromGitHub,
  gitMinimal,
  portaudio,
}:

let
  python3 = python311.override {
    self = python3;
    packageOverrides = _: super: { tree-sitter = super.tree-sitter_0_21; };
  };
  version = "0.56.0";
in
python3.pkgs.buildPythonApplication {
  pname = "aider-chat";
  inherit version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "paul-gauthier";
    repo = "aider";
    rev = "refs/tags/v${version}";
    hash = "sha256-e0Fqj67vYt41Zbr1FN2fuLp6cHRius8RtacBHLgB9dM=";
  };

  pythonRelaxDeps = true;

  build-system = with python3.pkgs; [ setuptools-scm ];

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
      json5
      jsonschema
      jiter
      litellm
      networkx
      numpy
      packaging
      pathspec
      pillow
      playwright
      prompt-toolkit
      pypager
      pypandoc
      pyperclip
      pyyaml
      rich
      scipy
      sounddevice
      soundfile
      streamlit
      tokenizers
      watchdog
    ]
    ++ lib.optionals (!tensorflow.meta.broken) [
      llama-index-core
      llama-index-embeddings-huggingface
    ];

  buildInputs = [ portaudio ];

  nativeCheckInputs = (with python3.pkgs; [ pytestCheckHook ]) ++ [ gitMinimal ];

  disabledTestPaths = [
    # Tests require network access
    "tests/scrape/test_scrape.py"
    # Expected 'mock' to have been called once
    "tests/help/test_help.py"
  ];

  disabledTests =
    [
      # Tests require network
      "test_urls"
      "test_get_commit_message_with_custom_prompt"
      # FileNotFoundError
      "test_get_commit_message"
      # Expected 'launch_gui' to have been called once
      "test_browser_flag_imports_streamlit"
      # AttributeError
      "test_simple_send_with_retries"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # Tests fails on darwin
      "test_dark_mode_sets_code_theme"
      "test_default_env_file_sets_automatic_variable"
    ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  meta = {
    description = "AI pair programming in your terminal";
    homepage = "https://github.com/paul-gauthier/aider";
    changelog = "https://github.com/paul-gauthier/aider/blob/v${version}/HISTORY.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ taha-yassine ];
    mainProgram = "aider";
  };
}
