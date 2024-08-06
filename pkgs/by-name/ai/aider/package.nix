{
  lib,
  python311Packages,
  fetchFromGitHub,
}:

# deps not working with python 3.12 yet
python311Packages.buildPythonApplication rec {
  pname = "aider";
  version = "0.47.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "paul-gauthier";
    repo = "aider";
    rev = "refs/tags/v${version}";
    hash = "sha256-PlkC88/WN4O3QdFGjBEVkl7ateqIS/PRADAK00kXfHU=";
  };

  build-system = with python311Packages; [
    setuptools
    pythonRelaxDepsHook
  ];
  pythonRelaxDeps = true;

  dependencies = with python311Packages; [
    configargparse
    GitPython
    jsonschema
    rich
    prompt_toolkit
    backoff
    pathspec
    diskcache
    grep-ast
    packaging
    sounddevice
    soundfile
    beautifulsoup4
    pyyaml
    pillow
    diff-match-patch
    pypandoc
    litellm
    flake8
    importlib-resources

    networkx
    scipy
    tree-sitter0_21
    tree-sitter-languages
    importlib-metadata
    numpy_1
  ];

  pythonImportsCheck = [ "aider" ];

  meta = {
    description = "AI pair programming in your terminal";
    homepage = "https://aider.chat/";
    license = licenses.asl20;
    maintainers = with maintainers; [ viraptor ];
    platforms = platforms.all;
  };
}
