{
  python3Packages,
  fetchFromGitHub,
  lib,
  nix-update-script,
}:

python3Packages.buildPythonApplication rec {
  pname = "pandoc-include";
  version = "1.4.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "DCsunset";
    repo = "pandoc-include";
    tag = "v${version}";
    hash = "sha256-8ldIywvCExnbMNs9m7iLwM1HrTRHl7j4t3JQuBt0Z7U=";
  };

  build-system = [
    python3Packages.setuptools
  ];

  passthru.updateScript = nix-update-script { };

  propagatedBuildInputs = [
    python3Packages.natsort
    python3Packages.panflute
    python3Packages.lxml
  ];

  pythonImportsCheck = [ "pandoc_include.main" ];

  meta = {
    description = "Pandoc filter to allow file and header includes";
    homepage = "https://github.com/DCsunset/pandoc-include";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      ppenguin
      DCsunset
    ];
    mainProgram = "pandoc-include";
  };
}
