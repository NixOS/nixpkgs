{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication rec {
  pname = "lsdisplay";
  version = "0.2.5";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-UhYJkrL5gr+8nCGmV9PfJzCCm7AqLhKKdo/2HVc2o1c=";
  };

  build-system = [ python3Packages.setuptools ];

  # Script Python 3 autonome, aucune dependance d'execution.
  pythonImportsCheck = [ "lsdisplay" ];

  # Tests unittest embarques : ils s'auto-invoquent (--help/--version) et
  # mockent le reste, donc ils tournent sans serveur X.
  checkPhase = ''
    runHook preCheck
    python -m unittest discover -s tests -v
    runHook postCheck
  '';

  meta = {
    description = "List connected displays — like lsusb/lspci but for screens";
    homepage = "https://github.com/AGuyMarc/lsdisplay";
    changelog = "https://github.com/AGuyMarc/lsdisplay/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.gpl2Plus;
    mainProgram = "lsdisplay";
    maintainers = with lib.maintainers; [ guy-marc-aprin ];
    platforms = lib.platforms.linux;
  };
}
