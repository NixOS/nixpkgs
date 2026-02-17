{
  lib,
  stdenv,
  python3,
  groff,
  less,
  fetchFromGitHub,
  fetchpatch,
  installShellFiles,
  nix-update-script,
  testers,
  awscli2,
  addBinToPathHook,
  writableTmpDirAsHomeHook,
}:

let
  py = python3 // {
    pkgs = python3.pkgs.overrideScope (
      final: prev: {
        # https://github.com/NixOS/nixpkgs/issues/449266
        prompt-toolkit = prev.prompt-toolkit.overridePythonAttrs (prev: rec {
          version = "3.0.51";
          src = prev.src.override {
            tag = version;
            hash = "sha256-pNYmjAgnP9nK40VS/qvPR3g+809Yra2ISASWJDdQKrU=";
          };
        });

        # backends/build_system/utils.py cannot parse PEP 440 version
        # for python-dateutil 2.9.0.post0 (eg. post0)
        python-dateutil = prev.python-dateutil.overridePythonAttrs (prev: rec {
          version = "2.8.2";
          format = "setuptools";
          pyproject = null;
          src = prev.src.override {
            inherit version;
            hash = "sha256-ASPKzBYnrhnd88J6XeW9Z+5FhvvdZEDZdI+Ku0g9PoY=";
          };
          patches = [
            # https://github.com/dateutil/dateutil/pull/1285
            (fetchpatch {
              url = "https://github.com/dateutil/dateutil/commit/f2293200747fb03d56c6c5997bfebeabe703576f.patch";
              relative = "src";
              hash = "sha256-BVEFGV/WGUz9H/8q+l62jnyN9VDnoSR71DdL+LIkb0o=";
            })
          ];
          postPatch = null;
        });
      }
    );
  };

in
py.pkgs.buildPythonApplication rec {
  pname = "awscli2";
  version = "2.33.2"; # N.B: if you change this, check if overrides are still up-to-date
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aws";
    repo = "aws-cli";
    tag = version;
    hash = "sha256-dAtcYDdrZASrwBjQfnZ4DUR4F5WhY59/UX92QcILavs=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'flit_core>=3.7.1,<3.9.1' 'flit_core>=3.7.1' \
      --replace-fail 'awscrt==' 'awscrt>=' \
      --replace-fail 'distro>=1.5.0,<1.9.0' 'distro>=1.5.0' \
      --replace-fail 'docutils>=0.10,<0.20' 'docutils>=0.10' \
      --replace-fail 'prompt-toolkit>=3.0.24,<3.0.52' 'prompt-toolkit>=3.0.24' \
      --replace-fail 'ruamel.yaml>=0.15.0,<=0.17.21' 'ruamel.yaml>=0.15.0' \
      --replace-fail 'ruamel.yaml.clib>=0.2.0,<=0.2.12' 'ruamel.yaml.clib>=0.2.0'

    substituteInPlace requirements-base.txt \
      --replace-fail "wheel==0.43.0" "wheel>=0.43.0"

    # Upstream needs pip to build and install dependencies and validates this
    # with a configure script, but we don't as we provide all of the packages
    # through PYTHONPATH
    sed -i '/pip>=/d' requirements/bootstrap.txt
  '';

  nativeBuildInputs = [
    installShellFiles
  ];

  build-system = with py.pkgs; [
    flit-core
  ];

  dependencies = with py.pkgs; [
    awscrt
    colorama
    distro
    docutils
    jmespath
    prompt-toolkit
    python-dateutil
    ruamel-yaml
    urllib3
  ];

  propagatedBuildInputs = [
    groff
    less
  ];

  # Prevent breakage when running in a Python environment: https://github.com/NixOS/nixpkgs/issues/47900
  makeWrapperArgs = [
    "--unset"
    "NIX_PYTHONPATH"
    "--unset"
    "PYTHONPATH"
  ];

  nativeCheckInputs = with py.pkgs; [
    addBinToPathHook
    jsonschema
    mock
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  postInstall = ''
    installShellCompletion --cmd aws \
      --bash <(echo "complete -C $out/bin/aws_completer aws") \
      --zsh $out/bin/aws_zsh_completer.sh
  ''
  + lib.optionalString (!stdenv.hostPlatform.isWindows) ''
    rm $out/bin/aws.cmd
  '';

  # Propagating dependencies leaks them through $PYTHONPATH which causes issues
  # when used in nix-shell.
  postFixup = ''
    rm $out/nix-support/propagated-build-inputs
  '';

  # tests/unit/customizations/sso/test_utils.py uses sockets
  __darwinAllowLocalNetworking = true;

  pytestFlags = [
    "-Wignore::DeprecationWarning"
  ];

  disabledTestPaths = [
    "tests/dependencies"
    "tests/unit/botocore"

    # Integration tests require networking
    "tests/integration"

    # Disable slow tests (only run unit tests)
    "tests/backends"
    "tests/functional"
  ];

  disabledTests = [
    # Requires networking (socket binding not possible in sandbox)
    "test_is_socket"
    "test_is_special_file_warning"

    # Disable slow tests
    "test_details_disabled_for_choice_wo_details"
  ];

  pythonImportsCheck = [
    "awscli"
  ];

  passthru = {
    python = py; # for aws_shell
    updateScript = nix-update-script {
      # Excludes 1.x versions from the Github tags list
      extraArgs = [
        "--version-regex"
        "^(2\\.(.*))"
      ];
    };
    tests.version = testers.testVersion {
      package = awscli2;
      command = "aws --version";
      inherit version;
    };
  };

  meta = {
    description = "Unified tool to manage your AWS services";
    homepage = "https://aws.amazon.com/cli/";
    changelog = "https://github.com/aws/aws-cli/blob/${version}/CHANGELOG.rst";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      davegallant
      devusb
      anthonyroussel
    ];
    mainProgram = "aws";
  };
}
