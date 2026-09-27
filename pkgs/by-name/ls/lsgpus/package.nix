{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication rec {
  pname = "lsgpus";
  version = "0.2.6";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8IRbkhu3CbbjONFOo2wLI0dubWBcKA8E1knUBmpZvgE=";
  };

  build-system = [ python3Packages.setuptools ];

  # Le module importe s'appelle "lsgpu" ; le binaire installe est "lsgpus"
  # (le nom "lsgpu" est deja pris par /usr/bin/lsgpu d'igt-gpu-tools).
  pythonImportsCheck = [ "lsgpu" ];

  # Tests unittest embarques : ils s'auto-invoquent (--help/--version) et
  # mockent le reste, donc ils tournent sans GPU ni nvidia-smi/rocm-smi.
  checkPhase = ''
    runHook preCheck
    python -m unittest discover -s tests -v
    runHook postCheck
  '';

  meta = {
    description = "List GPUs with details — like lscpu/lsusb but for graphics cards";
    homepage = "https://github.com/AGuyMarc/lsgpu";
    changelog = "https://github.com/AGuyMarc/lsgpu/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.gpl2Plus;
    mainProgram = "lsgpus";
    maintainers = with lib.maintainers; [ guy-marc-aprin ];
    platforms = lib.platforms.linux;
  };
}
