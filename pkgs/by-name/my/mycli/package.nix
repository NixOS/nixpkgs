{
  lib,
  fetchFromGitHub,
  python3Packages,
  writableTmpDirAsHomeHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "mycli";
  version = "2.32.0";
  pyproject = true;

  # test_ssh_tunnel.py binds to localhost to find a free port; the darwin
  # sandbox blocks loopback networking unless this is enabled
  __darwinAllowLocalNetworking = true;

  src = fetchFromGitHub {
    owner = "dbcli";
    repo = "mycli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3Di1YoLR2x87Fjswi2h4trewYgi2gCsSx5fdu1eThYc=";
  };

  pythonRelaxDeps = [
    "pygments"
    "pymysql"
    "wcwidth"
    "sqlglot"
    "sqlglotc"
    "sqlparse"
    "click"
    "cryptography"
    "cli_helpers"
    "yaspin"
  ];

  build-system = with python3Packages; [
    setuptools
    setuptools-scm
  ];

  dependencies =
    with python3Packages;
    [
      altair
      cli-helpers
      click
      clickdc
      configobj
      cryptography
      jinja2
      keyring
      llm
      polars
      prompt-toolkit
      pycryptodomex
      pygments
      pymysql
      pyperclip
      rapidfuzz
      sqlglot
      sqlparse
      pyfzf
      wcwidth
    ]
    ++ cli-helpers.optional-dependencies.styles
    ++ [ yaspin ];

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
  ]
  ++ (with python3Packages; [
    pytestCheckHook
    pytest-random-order
  ]);

  pytestFlags = [
    # bash completion harness is sensitive to the system bash version and
    # exercises only the static completion script, not the packaged code
    "--deselect=mycli_test/pytests/test_bash_completion.py::test_bash_completion_matches_mycli_completion_behavior"
  ];

  meta = {
    description = "Command-line interface for MySQL";
    mainProgram = "mycli";
    longDescription = ''
      Rich command-line interface for MySQL with auto-completion and
      syntax highlighting.
    '';
    homepage = "http://mycli.net";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ jojosch ];
  };
})
