{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "isolyzer";
  version = "1.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "KBNLresearch";
    repo = "isolyzer";
    tag = finalAttrs.version;
    sha256 = "sha256-NqkjnEwpaoyguG5GLscKS9UQGtF9N4jUL5JhrMtKCFE=";
  };

  build-system = with python3.pkgs; [
    setuptools
  ];

  dependencies = with python3.pkgs; [
    six
  ];

  pythonImportsCheck = [ "isolyzer" ];

  meta = {
    homepage = "https://github.com/KBNLresearch/isolyzer";
    description = "Verify size of ISO 9660 image against Volume Descriptor fields";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mkg20001 ];
    mainProgram = "isolyzer";
  };
})
