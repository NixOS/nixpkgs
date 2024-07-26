{
  stdenv,
  buildPythonApplication,
  fetchFromGitHub,
  isPyPy,
  lib,
  defusedxml,
  future,
  ujson,
  packaging,
  psutil,
  setuptools,
  pydantic,
  # Optional dependencies:
  fastapi,
  jinja2,
  orjson,
  pysnmp,
  hddtemp,
  netifaces, # IP module
  py-cpuinfo,
  uvicorn,
  requests,
  prometheus-client,
}:

buildPythonApplication rec {
  pname = "glances";
  version = "4.1.2.1";
  disabled = isPyPy;

  src = fetchFromGitHub {
    owner = "nicolargo";
    repo = "glances";
    rev = "refs/tags/v${version}";
    hash = "sha256-SlKt+wjzI9QRmMVvbIERuhQuCCaOh7L89WuNUXNhkuI=";
  };

  # On Darwin this package segfaults due to mismatch of pure and impure
  # CoreFoundation. This issues was solved for binaries but for interpreted
  # scripts a workaround below is still required.
  # Relevant: https://github.com/NixOS/nixpkgs/issues/24693
  makeWrapperArgs = lib.optionals stdenv.isDarwin [
    "--set"
    "DYLD_FRAMEWORK_PATH"
    "/System/Library/Frameworks"
  ];

  doCheck = true;
  preCheck = lib.optionalString stdenv.isDarwin ''
    export DYLD_FRAMEWORK_PATH=/System/Library/Frameworks
  '';

  propagatedBuildInputs = [
    defusedxml
    future
    ujson
    netifaces
    packaging
    psutil
    pysnmp
    setuptools
    py-cpuinfo
    pydantic
    fastapi
    uvicorn
    requests
    jinja2
    orjson
    prometheus-client
  ] ++ lib.optional stdenv.isLinux hddtemp;

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
