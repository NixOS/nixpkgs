{
  acpica-tools,
  ethtool,
  fetchgit,
  lib,
  libdisplay-info,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "amd-debug-tools";
  version = "0.2.10";
  pyproject = true;

  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/linux/kernel/git/superm1/amd-debug-tools.git";
    rev = version;
    hash = "sha256-tbykQ8tc6YKHjKEHA9Ml7Z7MjDQzMGXtTwMG9buiovg=";
  };

  build-system = with python3Packages; [
    setuptools
    setuptools-scm
  ];

  dependencies = with python3Packages; [
    dbus-fast
    jinja2
    matplotlib
    packaging
    pandas
    pyudev
    seaborn
    tabulate
  ];

  # Not available in nixpkgs as of 2025-11-15.
  pythonRemoveDeps = [
    "cysystemd"
  ];

  makeWrapperArgs = [
    "--prefix PATH : ${
      lib.makeBinPath [
        acpica-tools
        ethtool
        libdisplay-info
      ]
    }"
  ];

  # Tests require hardware-specific features
  doCheck = false;

  meta = {
    description = "Debug tools for AMD systems";
    homepage = "https://git.kernel.org/pub/scm/linux/kernel/git/superm1/amd-debug-tools.git/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ samuela ];
    platforms = lib.platforms.linux;
    mainProgram = "amd-s2idle";
  };
}
