{
  lib,
  python3,
  fetchFromGitHub,
  runtimeShell,
  installShellFiles,
  testers,
  pdm,
}:

let
  python = python3.override {
    self = python;
    packageOverrides = _: super: {
      resolvelib = super.resolvelib.overridePythonAttrs (old: rec {
        version = "1.1.0";
        src = old.src.override {
          tag = version;
          hash = "sha256-UBdgFN+fvbjz+rp8+rog8FW2jwO/jCfUPV7UehJKiV8=";
        };
      });
      # pdm requires ...... -> ghostscript-with-X which is AGPL only
      matplotlib = super.matplotlib.override ({ enableTk = false; });
      # pdm requires ...... -> jbig2dec which is AGPL only
      moto = super.moto.overridePythonAttrs (old: rec {
        doCheck = false;
      });
    };
  };
in
python.pkgs.buildPythonApplication rec {
  pname = "pdm";
  version = "2.25.9";
  pyproject = true;

  disabled = python.pkgs.pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pdm-project";
    repo = "pdm";
    tag = version;
    hash = "sha256-Oq3xOxP6huK9sppum9SFoKUsEZNmXdTuuhhy1UqAk/Q=";
  };

  pythonRelaxDeps = [ "hishel" ];

  nativeBuildInputs = [ installShellFiles ];

  build-system = with python.pkgs; [
    pdm-backend
    pdm-build-locked
  ];

  dependencies =
    with python.pkgs;
    [
      blinker
      dep-logic
      filelock
      findpython
      hishel
      httpx
      installer
      msgpack
      packaging
      pbs-installer
      platformdirs
      pyproject-hooks
      python-dotenv
      resolvelib
      rich
      shellingham
      tomlkit
      truststore
      unearth
      id
      virtualenv
    ]
    ++ httpx.optional-dependencies.socks;

  makeWrapperArgs = [ "--set PDM_CHECK_UPDATE 0" ];

  # Silence network warning during pypaInstallPhase
  # by disabling latest version check
  preInstall = ''
    export PDM_CHECK_UPDATE=0
  '';

  postInstall = ''
    export PDM_LOG_DIR=/tmp/pdm/log
    $out/bin/pdm completion bash >pdm.bash
    $out/bin/pdm completion fish >pdm.fish
    $out/bin/pdm completion zsh >pdm.zsh
    installShellCompletion pdm.{bash,fish,zsh}
    unset PDM_LOG_DIR
  '';

  nativeCheckInputs = with python.pkgs; [
    first
    pytestCheckHook
    pytest-mock
    pytest-xdist
    pytest-httpserver
  ];

  disabledTestMarks = [ "network" ];

  preCheck = ''
    export HOME=$TMPDIR
    substituteInPlace tests/cli/test_run.py \
      --replace-fail "/bin/bash" "${runtimeShell}"
  '';

  disabledTests = [
    # fails to locate setuptools (maybe upstream bug)
    "test_convert_setup_py_project"
    # pythonfinder isn't aware of nix's python infrastructure
    "test_use_wrapper_python"
    "test_build_with_no_isolation"
    "test_run_script_with_inline_metadata"

    # touches the network
    "test_find_candidates_from_find_links"
    "test_lock_all_with_excluded_groups"
    "test_find_interpreters_with_PDM_IGNORE_ACTIVE_VENV"
    "test_build_distributions"
    "test_init_project_respect"
    "test_use_python_write_file_multiple_versions"
    "test_repository_get_token_from_oidc"
    "test_repository_get_token_misconfigured_github"

    # https://github.com/pdm-project/pdm/issues/3590
    "test_install_from_lock_with_higher_version"
  ];

  __darwinAllowLocalNetworking = true;

  passthru.tests.version = testers.testVersion { package = pdm; };

  meta = {
    homepage = "https://pdm-project.org";
    changelog = "https://github.com/pdm-project/pdm/releases/tag/${version}";
    description = "Modern Python package and dependency manager supporting the latest PEP standards";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      cpcloud
      natsukium
      misilelab
    ];
    mainProgram = "pdm";
  };
}
