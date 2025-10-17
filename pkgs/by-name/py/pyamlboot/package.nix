{
  lib,
  fetchFromGitHub,
  python3Packages,
  testers,
  pyamlboot,
}:

python3Packages.buildPythonApplication rec {
  pname = "pyamlboot";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "superna9999";
    repo = "pyamlboot";
    tag = version;
    hash = "sha256-vpWq8+0ZoTkfVyx+2BbXdULFwo/Ug4U1gWArXDfnzyk=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    pyusb
    setuptools # pkg_resources is imported during runtime
  ];

  pythonImportsCheck = [ "pyamlboot" ];

  passthru.tests.version = testers.testVersion {
    package = pyamlboot;
    command = "boot.py -v";
    version = "boot.py ${lib.versions.majorMinor version}";
  };

  meta = {
    description = "Amlogic USB Boot Protocol Library";
    homepage = "https://github.com/superna9999/pyamlboot";
    license = with lib.licenses; [
      asl20
      gpl2Only
      mit
    ];
    maintainers = with lib.maintainers; [ genga898 ];
    mainProgram = "boot.py";
  };
}
