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
  version = "0.65.0";
  aider-chat = python3.pkgs.buildPythonApplication {
    pname = "aider-chat";
    inherit version;
    pyproject = true;

    src = fetchFromGitHub {
      owner = "Aider-AI";
      repo = "aider";
      rev = "refs/tags/v${version}";
      hash = "sha256-crQnkTOujflBcAAOY8rjgSEioM/9Vxud3UfgipJ07uA=";
    };

    pythonRelaxDeps = true;

    build-system = with python3.pkgs; [ setuptools-scm ];

    dependencies = with python3.pkgs; [
      aiohappyeyeballs
      aiohttp
      aiosignal
      annotated-types
      anyio
      attrs
      backoff
      beautifulsoup4
      certifi
      cffi
      charset-normalizer
      click
      configargparse
      diff-match-patch
      diskcache
      distro
      filelock
      flake8
      frozenlist
      fsspec
      gitdb
      gitpython
      grep-ast
      h11
      httpcore
      httpx
      huggingface-hub
      idna
      importlib-resources
      jinja2
      jiter
      json5
      jsonschema
      jsonschema-specifications
      litellm
      markdown-it-py
      markupsafe
      mccabe
      mdurl
      multidict
      networkx
      numpy
      openai
      packaging
      pathspec
      pexpect
      pillow
      prompt-toolkit
      psutil
      ptyprocess
      pycodestyle
      pycparser
      pydantic
      pydantic-core
      pydub
      pyflakes
      pygments
      pypandoc
      pyperclip
      python-dotenv
      pyyaml
      referencing
      regex
      requests
      rich
      rpds-py
      scipy
      smmap
      sniffio
      sounddevice
      soundfile
      soupsieve
      tiktoken
      tokenizers
      tqdm
      tree-sitter
      tree-sitter-languages
      typing-extensions
      urllib3
      wcwidth
      yarl
      zipp

      # Not listed in requirements
      mixpanel
      monotonic
      posthog
      propcache
      python-dateutil
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
        # Expected 'check_version' to have been called once
        "test_main_exit_calls_version_check"
      ]
      ++ lib.optionals stdenv.hostPlatform.isDarwin [
        # Tests fails on darwin
        "test_dark_mode_sets_code_theme"
        "test_default_env_file_sets_automatic_variable"
        # FileNotFoundError: [Errno 2] No such file or directory: 'vim'
        "test_pipe_editor"
      ];

    makeWrapperArgs = [
      "--set AIDER_CHECK_UPDATE false"
    ];

    preCheck = ''
      export HOME=$(mktemp -d)
    '';

    optional-dependencies = with python3.pkgs; {
      playwright = [
        greenlet
        playwright
        pyee
        typing-extensions
      ];
    };

    passthru = {
      withPlaywright = aider-chat.overridePythonAttrs (
        { dependencies, ... }:
        {
          dependencies = dependencies ++ aider-chat.optional-dependencies.playwright;
        }
      );
    };

    meta = {
      description = "AI pair programming in your terminal";
      homepage = "https://github.com/paul-gauthier/aider";
      changelog = "https://github.com/paul-gauthier/aider/blob/v${version}/HISTORY.md";
      license = lib.licenses.asl20;
      maintainers = with lib.maintainers; [ taha-yassine ];
      mainProgram = "aider";
    };
  };
in
aider-chat
