{ lib, stdenv, python312Packages, fetchFromGitHub, replaceVars, gitMinimal
, portaudio, playwright-driver, nix-update-script, }:

let
  # dont support python 3.13 (Aider-AI/aider#3037)
  python3Packages = python312Packages;

  aider-nltk-data =
    python3Packages.nltk.dataDir (d: [ d.punkt-tab d.stopwords ]);

  version = "0.87.11.dev";
  aider-ce = python3Packages.buildPythonApplication {
    pname = "aider-ce";
    inherit version;
    pyproject = true;

    src = fetchFromGitHub {
      owner = "dwash96";
      repo = "aider-ce";
      tag = "v${version}";
      hash = "sha256-hI7TfP6ij5TdLSM+WjGAT492ATMWfK69D3Yj6moNLrs=";
    };

    pythonRelaxDeps = true;

    build-system = with python3Packages; [ setuptools-scm ];

    dependencies = with python3Packages; [
      aiohappyeyeballs
      aiohttp
      aiosignal
      annotated-types
      anyio
      attrs
      backoff
      beautifulsoup4
      cachetools
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
      google-ai-generativelanguage
      google-generativeai
      grep-ast
      h11
      hf-xet
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
      oslex
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
      shtab
      smmap
      sniffio
      sounddevice
      socksio
      soundfile
      soupsieve
      tiktoken
      tokenizers
      tqdm
      tree-sitter
      tree-sitter-language-pack
      typing-extensions
      typing-inspection
      urllib3
      watchfiles
      wcwidth
      yarl
      zipp
      pip

      # Not listed in requirements
      mixpanel
      monotonic
      posthog
      propcache
      python-dateutil
      mcp
    ];

    buildInputs = [ portaudio ];

    nativeCheckInputs = [ python3Packages.pytestCheckHook gitMinimal ];

    patches = [
      # ./fix-tree-sitter.patch

      (replaceVars ./fix-flake8-invoke.patch {
        flake8 = lib.getExe python3Packages.flake8;
      })
    ];

    disabledTestPaths = [
      # Tests require network access
      "tests/scrape/test_scrape.py"
      # Expected 'mock' to have been called once
      "tests/help/test_help.py"
      # "tests/basic/test_coder.py"
      # "tests/basic/test_commands.py"
      # "tests/basic/test_deprecated.py"
      # "tests/basic/test_editblock.py"
      # "tests/basic/test_find_or_blocks.py"
      # "tests/basic/test_main.py"
      # "tests/basic/test_reasoning.py"
      # "tests/basic/test_repomap.py"
      # "tests/basic/test_sanity_check_repo.py"
      # "tests/basic/test_scripting.py"
      # "tests/basic/test_ssl_verification.py"
      # "tests/basic/test_udiff.py"
      # "tests/basic/test_wholefile.py"
      # "tests/browser/test_browser.py"
    ];

    disabledTests = [
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
      # AssertionError: assert 2 == 1
      "test_simple_send_non_retryable_error"
    ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # Tests fails on darwin
      "test_dark_mode_sets_code_theme"
      "test_default_env_file_sets_automatic_variable"
      # FileNotFoundError: [Errno 2] No such file or directory: 'vim'
      "test_pipe_editor"
    ];

    makeWrapperArgs = [
      "--set"
      "AIDER_CHECK_UPDATE"
      "false"
      "--set"
      "AIDER_ANALYTICS"
      "false"
    ];

    preCheck = ''
      export HOME=$(mktemp -d)
      export AIDER_ANALYTICS="false"
    '';

    optional-dependencies = with python3Packages; {
      playwright = [ greenlet playwright pyee typing-extensions ];
      browser = [ streamlit ];
      help = [ llama-index-core llama-index-embeddings-huggingface torch nltk ];
      bedrock = [ boto3 ];
    };

    passthru = {
      withOptional = { withAll ? false, withPlaywright ? withAll
        , withBrowser ? withAll, withHelp ? withAll, withBedrock ? withAll, ...
        }:
        aider-ce.overridePythonAttrs ({ pname, dependencies, makeWrapperArgs
          , propagatedBuildInputs ? [ ], ... }:

          {
            pname = pname + lib.optionalString withPlaywright "-playwright"
              + lib.optionalString withBrowser "-browser"
              + lib.optionalString withHelp "-help"
              + lib.optionalString withBedrock "-bedrock";

            dependencies = dependencies ++ lib.optionals withPlaywright
              aider-ce.optional-dependencies.playwright
              ++ lib.optionals withBrowser
              aider-ce.optional-dependencies.browser
              ++ lib.optionals withHelp aider-ce.optional-dependencies.help
              ++ lib.optionals withBedrock
              aider-ce.optional-dependencies.bedrock;

            propagatedBuildInputs = propagatedBuildInputs
              ++ lib.optionals withPlaywright [ playwright-driver.browsers ];

            makeWrapperArgs = makeWrapperArgs ++ lib.optionals withPlaywright [
              "--set"
              "PLAYWRIGHT_BROWSERS_PATH"
              "${playwright-driver.browsers}"
              "--set"
              "PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS"
              "true"
            ] ++ lib.optionals withHelp [
              "--set"
              "NLTK_DATA"
              "${aider-nltk-data}"
            ];
          });

      updateScript =
        nix-update-script { extraArgs = [ "--version-regex" "^v([0-9.]+)$" ]; };
    };

    meta = {
      description = "AI pair programming in your terminal (Aider Fork)";
      homepage = "https://github.com/dwash96/aider-ce";
      changelog =
        "https://github.com/dwash96/aider-ce/blob/v${version}/HISTORY.md";
      license = lib.licenses.asl20;
      maintainers = with lib.maintainers; [ ];
      mainProgram = "aider-ce";
    };
  };
in aider-ce
