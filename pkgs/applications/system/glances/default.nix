{ stdenv, buildPythonApplication, fetchFromGitHub, fetchpatch, isPyPy, lib
, future, psutil, setuptools
# Optional dependencies:
, bottle, pysnmp
, hddtemp
, netifaces # IP module
, py-cpuinfo
}:

buildPythonApplication rec {
  pname = "glances";
  version = "3.1.5";
  disabled = isPyPy;

  src = fetchFromGitHub {
    owner = "nicolargo";
    repo = "glances";
    rev = "v${version}";
    sha256 = "0l91nvlwyabxlsy5p533dqnc68mmvykfsrcsnxylcpjjl1nzy931";
  };

  # Some tests fail in the sandbox (they e.g. require access to /sys/class/power_supply):
  patches = lib.optional (doCheck && stdenv.isLinux) ./skip-failing-tests.patch;

  # On Darwin this package segfaults due to mismatch of pure and impure
  # CoreFoundation. This issues was solved for binaries but for interpreted
  # scripts a workaround below is still required.
  # Relevant: https://github.com/NixOS/nixpkgs/issues/24693
  makeWrapperArgs = lib.optionals stdenv.isDarwin [
    "--set" "DYLD_FRAMEWORK_PATH" "/System/Library/Frameworks"
  ];

  doCheck = true;
  preCheck = lib.optional stdenv.isDarwin ''
    export DYLD_FRAMEWORK_PATH=/System/Library/Frameworks
  '';

  propagatedBuildInputs = [
    bottle
    future
    netifaces
    psutil
    pysnmp
    setuptools
    py-cpuinfo
  ] ++ lib.optional stdenv.isLinux hddtemp;

  preConfigure = ''
    sed -i 's/data_files\.append((conf_path/data_files.append(("etc\/glances"/' setup.py;
  '';

  meta = with lib; {
    homepage = "https://nicolargo.github.io/glances/";
    description = "Cross-platform curses-based monitoring tool";
    changelog = "https://github.com/nicolargo/glances/releases/tag/v${version}";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ jonringer primeos koral ];
  };
}
