{
  lib,
  stdenv,
  python3Packages,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

let
  # google-colab-cli pins jupyter-kernel-client==0.9.0, and 1.x changed the
  # websocket client (it now sends `extra_params` in the URL, and `stop_channels`
  # closes the socket differently), so keep 0.9.0 private to this package.
  jupyter-kernel-client = python3Packages.buildPythonPackage (finalAttrs: {
    pname = "jupyter-kernel-client";
    version = "0.9.0";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "datalayer";
      repo = "jupyter-kernel-client";
      # Upstream did not tag 0.9.0; this is the "bump: version" commit.
      rev = "ffc57eee7db20cc7acf0417d580b7b63d7ddda43";
      hash = "sha256-sLB0Evj1/nWA3hVNWLIh+4gRsipFlYccXzQN7os9q1U=";
    };

    build-system = [ python3Packages.hatchling ];

    dependencies = with python3Packages; [
      jupyter-client
      jupyter-core
      jupyter-mimetypes
      requests
      traitlets
      typing-extensions
      websocket-client
    ];

    nativeCheckInputs = with python3Packages; [
      pytest-asyncio
      pytest-timeout
      pytestCheckHook
    ];

    # These tests run code on a local ipykernel, and ipykernel 7.0 to 7.3 can
    # leave a request unanswered, so a test hangs until it times out
    # (ipython/ipykernel#1529, fixed in 7.4).
    disabledTestPaths = [
      "jupyter_kernel_client/tests/test_client.py"
      "jupyter_kernel_client/tests/test_manager.py"
    ];

    pythonImportsCheck = [ "jupyter_kernel_client" ];
  });
in
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "google-colab-cli";
  version = "0.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "googlecolab";
    repo = "google-colab-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/sAyxmZNERy56LUlghvN7O/U4oSfQMk1tE70tMpsA+s=";
  };

  env.SETUPTOOLS_SCM_PRETEND_VERSION = finalAttrs.version;

  # Disable the daily update check against PyPI by default.
  postPatch = ''
    substituteInPlace src/colab_cli/state.py \
      --replace-fail "enable_update_check: bool = True" "enable_update_check: bool = False"
  '';

  build-system = with python3Packages; [
    hatch-vcs
    hatchling
  ];

  dependencies = with python3Packages; [
    click
    filelock
    google-auth
    google-auth-oauthlib
    html2text
    jupyter-kernel-client
    keyring
    nbformat
    packaging
    prompt-toolkit
    pydantic
    pygments
    requests
    rich
    typer
    typing-extensions
    websocket-client
  ];

  nativeBuildInputs = [ installShellFiles ];

  # _TYPER_COMPLETE_TEST_DISABLE_SHELL_DETECTION: without it, typer ignores the
  # shell given to --show-completion and detects the running shell instead.
  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    export _TYPER_COMPLETE_TEST_DISABLE_SHELL_DETECTION=1

    installShellCompletion --cmd colab \
      --bash <($out/bin/colab --show-completion bash) \
      --fish <($out/bin/colab --show-completion fish) \
      --zsh <($out/bin/colab --show-completion zsh)
  '';

  nativeCheckInputs = with python3Packages; [
    pytest-mock
    pytestCheckHook
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  versionCheckProgramArg = "version";
  # `colab` writes its log under $HOME/.config/colab-cli on every run.
  versionCheckKeepEnvironment = [ "HOME" ];

  # tests/test_ssh_wire_contract.py starts a websocket server on 127.0.0.1.
  __darwinAllowLocalNetworking = true;

  # These tests expect the update check to be enabled by default (see postPatch).
  disabledTests = [
    "test_settings_store_defaults"
    "test_background_check_includes_disable_hint"
    "test_cached_banner_includes_disable_hint"
    "test_auto_update_runs_when_stale"
    "test_auto_update_runs_on_first_invocation"
    "test_cached_banner_shown_when_throttled"
  ];

  pythonImportsCheck = [ "colab_cli" ];

  meta = {
    description = "CLI for interacting with Google Colab runtimes";
    homepage = "https://github.com/googlecolab/google-colab-cli";
    changelog = "https://github.com/googlecolab/google-colab-cli/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.ryota2357 ];
    mainProgram = "colab";
  };
})
