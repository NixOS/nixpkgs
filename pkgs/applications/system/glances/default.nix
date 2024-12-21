{
  stdenv,
  buildPythonApplication,
  fetchFromGitHub,
  fetchpatch,
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

  patches = [
    # Fixes KeyError: 'bytes_sent_rate_per_sec' traceback on startup
    # Remove on releases after 4.2.1
    (fetchpatch {
      name = "KeyError_bytes_sent_rate_per_sec.patch";
      url = "https://github.com/nicolargo/glances/commit/07656fd7ff67e4b189aa14ca1645c90a580d72f1.patch";
      hash = "sha256-laE4pYGiaLqJh1CmGYkVHsFD2/4C5t0PfTLrGPVzvEs=";
    })
    # Fixes test_105_network_plugin_method failing on aarch64-linux
    # Remove on releases after 4.2.1
    (fetchpatch {
      name = "aarch64_linux-test_105_network_plugin_method.patch";
      url = "https://github.com/nicolargo/glances/commit/d9725d623f7d459232c2eb7a4887080772982447.patch";
      hash = "sha256-xLDAO8QmgvO9BnRbIs3nSROrJ2tIL9B/S/2vpS53hwQ=";
    })
  ];

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
