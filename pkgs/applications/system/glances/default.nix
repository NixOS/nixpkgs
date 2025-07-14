{
  stdenv,
  buildPythonApplication,
  fetchFromGitHub,
  isPyPy,
  pythonOlder,
  lib,
  defusedxml,
  packaging,
  psutil,
  setuptools,
  nixosTests,
  pytestCheckHook,
  which,
  podman,
  selenium,
  # Optional dependencies:
  fastapi,
  jinja2,
  pysnmp,
  hddtemp,
  netifaces2, # IP module
  uvicorn,
  requests,
  prometheus-client,
}:

buildPythonApplication rec {
  pname = "glances";
  version = "4.3.1";
  pyproject = true;

  disabled = isPyPy || pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "nicolargo";
    repo = "glances";
    tag = "v${version}";
    hash = "sha256-KaH2dV9bOtBZkfbIGIgQS8vL39XwSyatSjclcXpeVGM=";
  };

  build-system = [ setuptools ];

  # On Darwin this package segfaults due to mismatch of pure and impure
  # CoreFoundation. This issues was solved for binaries but for interpreted
  # scripts a workaround below is still required.
  # Relevant: https://github.com/NixOS/nixpkgs/issues/24693
  makeWrapperArgs = lib.optionals stdenv.hostPlatform.isDarwin [
    "--set"
    "DYLD_FRAMEWORK_PATH"
    "/System/Library/Frameworks"
  ];

  # some tests fail in darwin sandbox
  doCheck = !stdenv.hostPlatform.isDarwin;

  dependencies = [
    defusedxml
    netifaces2
    packaging
    psutil
    pysnmp
    fastapi
    uvicorn
    requests
    jinja2
    which
    prometheus-client
  ] ++ lib.optional stdenv.hostPlatform.isLinux hddtemp;

  passthru.tests = {
    service = nixosTests.glances;
  };

  nativeCheckInputs = [
    which
    pytestCheckHook
    selenium
    podman
  ];

  disabledTestPaths = [
    # Message: Unable to obtain driver for chrome
    "tests/test_webui.py"
  ];

  meta = {
    homepage = "https://nicolargo.github.io/glances/";
    description = "Cross-platform curses-based monitoring tool";
    mainProgram = "glances";
    changelog = "https://github.com/nicolargo/glances/blob/${src.tag}/NEWS.rst";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [
      koral
    ];
  };
}
