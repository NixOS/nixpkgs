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
          rev = version;
          hash = "sha256-UBdgFN+fvbjz+rp8+rog8FW2jwO/jCfUPV7UehJKiV8=";
        };
      });
    };
  };
in
python.pkgs.buildPythonApplication rec {
  pname = "pdm";
  version = "2.22.2";
  pyproject = true;

  disabled = python.pkgs.pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pdm-project";
    repo = "pdm";
    tag = version;
    hash = "sha256-se0Xvziyg4CU6wENO0oYVAI4f2uBv3Ubadiptf/uPgQ=";
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

  pytestFlagsArray = [ "-m 'not network'" ];

  preCheck = ''
    export HOME=$TMPDIR
    substituteInPlace tests/cli/test_run.py \
      --replace-warn "/bin/bash" "${runtimeShell}"
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
  ];

  __darwinAllowLocalNetworking = true;

  passthru.tests.version = testers.testVersion { package = pdm; };

  meta = with lib; {
    homepage = "https://pdm-project.org";
    changelog = "https://github.com/pdm-project/pdm/releases/tag/${version}";
    description = "Modern Python package and dependency manager supporting the latest PEP standards";
    license = licenses.mit;
    maintainers = with maintainers; [
      cpcloud
      natsukium
      misilelab
    ];
    mainProgram = "pdm";
  };
}
