{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication rec {
  pname = "konsave";
  version = "2.2.0";
  format = "pyproject";

  src = fetchPypi {
    inherit version;
    pname = "Konsave";
    hash = "sha256-tWarqT2jFgCuSsa2NwMHRaR3/wj0khiRHidvRNMwM8M=";
  };

  build-system = with python3Packages; [
    setuptools
    setuptools-scm
  ];

  dependencies = with python3Packages; [
    pyyaml
    setuptools # pkg_resources is imported during runtime
  ];

  pythonImportsCheck = [ "konsave" ];

  meta = with lib; {
    description = "Save Linux Customization";
    mainProgram = "konsave";
    maintainers = with maintainers; [ MoritzBoehme ];
    homepage = "https://github.com/Prayag2/konsave";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
