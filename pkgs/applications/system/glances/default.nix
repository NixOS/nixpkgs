{
  stdenv,
  buildPythonApplication,
  fetchFromGitHub,
  isPyPy,
  lib,
  defusedxml,
  packaging,
  psutil,
  setuptools,
  pydantic,
  nixosTests,
  # Optional dependencies:
  fastapi,
  jinja2,
  pysnmp,
  hddtemp,
  netifaces, # IP module
  uvicorn,
  requests,
  prometheus-client,
}:

buildPythonApplication rec {
  pname = "glances";
  version = "4.2.1";
  pyproject = true;

  disabled = isPyPy;

  src = fetchFromGitHub {
    owner = "nicolargo";
    repo = "glances";
    rev = "refs/tags/v${version}";
    hash = "sha256-8Jm6DE3B7OQkaNwX/KwXMNZHUyvPtln8mJYaD6yzJRM=";
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

  checkPhase = ''
    runHook preCheck

    python unittest-core.py

    runHook postCheck
  '';

  dependencies = [
    defusedxml
    netifaces
    packaging
    psutil
    pysnmp
    fastapi
    uvicorn
    requests
    jinja2
    prometheus-client
  ] ++ lib.optional stdenv.hostPlatform.isLinux hddtemp;

  passthru.tests = {
    service = nixosTests.glances;
  };

  meta = {
    homepage = "https://nicolargo.github.io/glances/";
    description = "Cross-platform curses-based monitoring tool";
    mainProgram = "glances";
    changelog = "https://github.com/nicolargo/glances/blob/v${version}/NEWS.rst";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [
      primeos
      koral
    ];
  };
}
