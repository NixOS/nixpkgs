{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

let
  pypkgs = python3Packages;

  version = "2.1-unstable-2025-03-28";

  src = fetchFromGitHub {
    owner = "JelmerT";
    repo = "cc2538-bsl";
    rev = "250e8616e6cb00f1b23cb251154de984ce506f7b";
    hash = "sha256-SNWHCSbaeO4s4W29Jly9bAEhFjfej9J9qn+mxxpoe30=";
  };

  version' = "${lib.versions.majorMinor version}.dev0+g${lib.substring 0 7 src.rev}";

in
pypkgs.buildPythonApplication rec {
  pname = "cc2538-bsl";
  inherit version src;
  pyproject = true;

  # if you happen to run cc2538-bsl from a git repository of any kind, you will get the
  # version of *that* rather than the application itself because it will run 'git describe'
  patches = [ ./do_not_run_git.patch ];

  postPatch = ''
    substituteInPlace cc2538_bsl/cc2538_bsl.py  \
      --replace-fail '__version__ = "2.1"' '__version__ = "${version'}"'
  '';

  env.SETUPTOOLS_SCM_PRETEND_VERSION = version';

  build-system = with pypkgs; [
    setuptools-scm
  ];

  dependencies = with pypkgs; [
    intelhex
    pyserial
    python-magic
  ];

  nativeCheckInputs = with pypkgs; [
    pytestCheckHook
    scripttest
  ];

  # we need to patch these tests to make them work inside our sandbox, so just disable them for
  # now as we run this in `postInstallCheck`
  disabledTests = [
    "test_help_output"
    "test_version"
  ];

  # this is just to ensure that `meta.mainProgram` exists and is executable since we disable `test_help_output`
  postInstallCheck = ''
    $out/bin/${meta.mainProgram} --help
  '';

  meta = {
    homepage = "https://github.com/JelmerT/cc2538-bsl";
    description = "Flash TI SimpleLink chips (CC2538, CC13xx, CC26xx) over serial";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ lorenz ];
    mainProgram = "cc2538-bsl";
  };
}
