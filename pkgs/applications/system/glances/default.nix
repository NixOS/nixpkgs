{ stdenv, buildPythonApplication, fetchFromGitHub, fetchpatch, isPyPy, lib
, defusedxml, future, ujson, packaging, psutil, setuptools
# Optional dependencies:
, bottle, pysnmp
, hddtemp
, netifaces # IP module
, py-cpuinfo
}:

buildPythonApplication rec {
  pname = "glances";
  version = "3.4.0.5";
  disabled = isPyPy;

  src = fetchFromGitHub {
    owner = "nicolargo";
    repo = "glances";
    rev = "refs/tags/v${version}";
    hash = "sha256-Ho4vcmTEVja7rkgLSfNkXvnpopYupRxPL1UVlnmdGCg=";
  };

  # On Darwin this package segfaults due to mismatch of pure and impure
  # CoreFoundation. This issues was solved for binaries but for interpreted
  # scripts a workaround below is still required.
  # Relevant: https://github.com/NixOS/nixpkgs/issues/24693
  makeWrapperArgs = lib.optionals stdenv.isDarwin [
    "--set" "DYLD_FRAMEWORK_PATH" "/System/Library/Frameworks"
  ];

  doCheck = true;
  preCheck = lib.optionalString stdenv.isDarwin ''
    export DYLD_FRAMEWORK_PATH=/System/Library/Frameworks
  '';

  propagatedBuildInputs = [
    bottle
    defusedxml
    future
    ujson
    netifaces
    packaging
    psutil
    pysnmp
    setuptools
    py-cpuinfo
  ] ++ lib.optional stdenv.isLinux hddtemp;

  meta = with lib; {
    homepage = "https://nicolargo.github.io/glances/";
    description = "Cross-platform curses-based monitoring tool";
    mainProgram = "glances";
    changelog = "https://github.com/nicolargo/glances/blob/v${version}/NEWS.rst";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ jonringer primeos koral ];
  };
}
