{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "konsave";
  version = "2.2.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) version;
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

  meta = {
    description = "Save Linux Customization";
    mainProgram = "konsave";
    maintainers = with lib.maintainers; [ MoritzBoehme ];
    homepage = "https://github.com/Prayag2/konsave";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
  };
})
