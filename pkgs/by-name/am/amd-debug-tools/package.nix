{
  lib,
  fetchgit,
  python3Packages,
  acpica-tools,
  ethtool,
  libdisplay-info,
}:

let
  version = "0.2.8";
in
python3Packages.buildPythonApplication {
  pname = "amd-debug-tools";
  inherit version;
  pyproject = true;

  build-system = with python3Packages; [
    pyudev
    setuptools
    setuptools-git
    setuptools-git-versioning
  ];
  dependencies = with python3Packages; [
    acpica-tools
    cysystemd
    dbus-fast
    ethtool
    jinja2
    libdisplay-info
    matplotlib
    pandas
    pyudev
    seaborn
    tabulate
  ];
  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/linux/kernel/git/superm1/amd-debug-tools.git";
    tag = version;
    hash = "sha256-EmXsW7Q5WMFL32LWr29W3GnGpw5aj53wlp9KbFV1r0Q=";
    leaveDotGit = true;
  };

  disabled = python3Packages.pythonOlder "3.7";

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail ', "setuptools-git-versioning>=2.0,<3"' ""
  '';

  pythonImportsCheck = [ "amd_debug" ];

  meta = {
    description = "Debug tools for AMD zen systems";
    homepage = "https://git.kernel.org/pub/scm/linux/kernel/git/superm1/amd-debug-tools.git/";
    changelog = "https://git.kernel.org/pub/scm/linux/kernel/git/superm1/amd-debug-tools.git/tag/?h=${version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
}
