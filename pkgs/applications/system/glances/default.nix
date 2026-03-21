{
  stdenv,
  buildPythonApplication,
  fetchFromGitHub,
  isPyPy,
  lib,
  defusedxml,
  packaging,
  psutil,
  pyinstrument,
  setuptools,
  nixosTests,
  pytestCheckHook,
  which,
  podman,
  selenium,
  python-jose,
  # Optional dependencies:
  fastapi,
  jinja2,
  pysnmp,
  hddtemp,
  uvicorn,
  requests,
  prometheus-client,
  shtab,
}:

buildPythonApplication rec {
  pname = "glances";
  version = "4.5.0.5";
  pyproject = true;

  disabled = isPyPy;

  src = fetchFromGitHub {
    owner = "nicolargo";
    repo = "glances";
    tag = "v${version}";
    hash = "sha256-IHgMZw+X7C/72w4vXaP37GgnhLVg7EF5/sd9QlmE0NM=";
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
    packaging
    psutil
    pyinstrument
    pysnmp
    fastapi
    uvicorn
    requests
    jinja2
    python-jose
    which
    prometheus-client
    shtab
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux hddtemp;

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

  disabledTests = [
    # Upstream bug: diskio plugin doesn't check if args is None before accessing attributes
    # Bug report: https://github.com/nicolargo/glances/issues/3429
    "test_msg_curse_returns_list"
    "test_msg_curse_with_max_width"
    # Network test expects visible network interfaces
    # Default config hides loopback and interfaces without IP (glances.conf)
    # In Nix sandbox environment, this results in zero visible interfaces
    "test_glances_api_plugin_network"
    # Test always returns 3 plugin updates, but needs >=5 to not fail
    # May be an upstream bug, see: https://github.com/nicolargo/glances/issues/3430
    "test_perf_update"
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
