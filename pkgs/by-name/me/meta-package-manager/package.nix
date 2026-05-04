{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "meta-package-manager";
  version = "6.4.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "kdeldycke";
    repo = "meta-package-manager";
    tag = "v${finalAttrs.version}";
    hash = "sha256-biC8JXGIb3lAuvyGgCtBoUZbSJtNPr7qLvoKLjnXarw=";
  };

  build-system = with python3Packages; [ uv-build ];

  dependencies = with python3Packages; [
    boltons
    click-extra
    cyclonedx-python-lib
    extra-platforms
    packageurl-python
    spdx-tools
    tomli-w
    xmltodict
  ];

  # mpm's test suite is integration-oriented: it spawns real package
  # manager binaries (apt, brew, pip, npm and ~30 others), makes network
  # calls, and assumes a writable ``$HOME``. None of this is reproducible
  # inside a hermetic builder. mpm's own GitHub Actions CI exercises the
  # full suite where the appropriate package managers are pre-installed;
  # the ``pythonImportsCheck`` below is sufficient to validate that the
  # package imports cleanly and its declared dependencies resolve.
  doCheck = false;

  pythonImportsCheck = [ "meta_package_manager" ];

  meta = {
    description = "CLI wrapping all package managers with a unifying interface";
    homepage = "https://kdeldycke.github.io/meta-package-manager/";
    changelog = "https://github.com/kdeldycke/meta-package-manager/blob/v${finalAttrs.version}/changelog.md";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ kdeldycke ];
    mainProgram = "mpm";
  };
})
