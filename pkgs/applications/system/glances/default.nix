{ stdenv, buildPythonApplication, fetchFromGitHub, fetchpatch, isPyPy, lib
, defusedxml, future, packaging, psutil, setuptools
# Optional dependencies:
, bottle, pysnmp
, hddtemp
, netifaces # IP module
, py-cpuinfo
}:

buildPythonApplication rec {
  pname = "glances";
  version = "3.2.6.4";
  disabled = isPyPy;

  src = fetchFromGitHub {
    owner = "nicolargo";
    repo = "glances";
    rev = "v${version}";
    sha256 = "sha256-i88bz6AwfDbqC+7yvr7uDofAqBwQmnfoKbt3iJz4Ft8=";
  };

  # Some tests fail in the sandbox (they e.g. require access to /sys/class/power_supply):
  patches = lib.optional (doCheck && stdenv.isLinux) ./skip-failing-tests.patch
    ++ lib.optional (doCheck && stdenv.isDarwin)
    [
      # Fix "TypeError: unsupported operand type(s) for +=: 'int' and 'NoneType'" on darwin
      # https://github.com/nicolargo/glances/pull/2082
      (fetchpatch {
        name = "fix-typeerror-when-testing-on-darwin.patch";
        url = "https://patch-diff.githubusercontent.com/raw/nicolargo/glances/pull/2082.patch";
        sha256 = "sha256-MIePPywZ2dTTqXjf7EJiHlQ7eltiHzgocqrnLeLJwZ4=";
      })
    ];

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
    changelog = "https://github.com/nicolargo/glances/blob/v${version}/NEWS.rst";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ jonringer primeos koral ];
  };
}
