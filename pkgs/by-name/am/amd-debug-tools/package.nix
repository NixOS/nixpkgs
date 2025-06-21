{
  lib,
  python3Packages,
  fetchgit,
  nix-update-script,

  # nativeBuildInputs
  wrapGAppsNoGuiHook,
  gobject-introspection,

  # propagatedBuildInputs
  acpica-tools,
  ethtool,
  fwupd,
  libdisplay-info,
  util-linux,
}:

python3Packages.buildPythonPackage rec {
  pname = "amd-debug-tools";
  version = "0.2.3";
  pyproject = true;

  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/linux/kernel/git/superm1/${pname}.git";
    tag = version;
    hash = "sha256-yWDpVHruVNUWaCUXkeBkXOeSOiW3D9fiQZ8B3Pkug3I=";
  };

  passthru.updateScript = nix-update-script { };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail ', "setuptools-git-versioning>=2.0,<3"' "" \
      --replace-fail 'dynamic = ["version"]' 'version = "${version}"'
  '';

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    cysystemd
    jinja2
    matplotlib
    packaging
    pandas
    pygobject3
    pyudev
    seaborn
    tabulate
  ];

  nativeBuildInputs = [
    wrapGAppsNoGuiHook
    gobject-introspection
  ];

  propagatedBuildInputs = [
    acpica-tools
    ethtool
    fwupd
    libdisplay-info
    util-linux
  ];

  meta = {
    description = "Helpful tools for debugging AMD Zen systems";
    homepage = "https://git.kernel.org/pub/scm/linux/kernel/git/superm1/amd-debug-tools.git/about";
    changelog = "https://git.kernel.org/pub/scm/linux/kernel/git/superm1/amd-debug-tools.git/tag/?h=${version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.tigergorilla2 ];
  };
}
