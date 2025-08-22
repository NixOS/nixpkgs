{
  lib,
  fetchgit,
  python3Packages,
  acpica-tools,
  ethtool,
  libdisplay-info,
}:

let
  version = "0.2.7";
in
python3Packages.buildPythonApplication {
  pname = "amd-debug-tools";
  inherit version;
  pyproject = true;

  build-system = with python3Packages; [
    setuptools
    setuptools-git-versioning
    setuptools-git
    pyudev
  ];
  dependencies = with python3Packages; [
    cysystemd
    jinja2
    matplotlib
    pandas
    pyudev
    seaborn
    tabulate
    acpica-tools
    ethtool
    libdisplay-info
  ];
  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/linux/kernel/git/superm1/amd-debug-tools.git";
    tag = version;
    hash = "sha256-6X9cUKN0BkkKcYGU+YJYCGT+l5iUZDN+D8Fqq/ns98Q=";
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
