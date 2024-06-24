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
  # use unstable to fix a build error for aarch64.
  version = "4.0.8-unstable-2024-06-09";
  disabled = isPyPy;

  src = fetchFromGitHub {
    owner = "nicolargo";
    repo = "glances";
    rev = "051006e12f7c90281dda4af60871b535b0dcdcb9";
    hash = "sha256-iCK5soTACQwtCVMmMsFaqXvZtTKX9WbTul0mUeSWC2M=";
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
      jonringer
      primeos
      koral
    ];
  };
}
