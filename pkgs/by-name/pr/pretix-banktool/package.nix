{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

let
  pythonPackages = python3Packages.overrideScope (
    self: super: {
      fints = self.fints_4;
    }
  );
in
pythonPackages.buildPythonApplication (finalAttrs: {
  pname = "pretix-banktool";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pretix";
    repo = "pretix-banktool";
    rev = "v${finalAttrs.version}";
    hash = "sha256-x6P+WqrOak5/gmMEmBkHrx6kPsbSOAXbKRbndFG3IJU=";
  };

  build-system = with pythonPackages; [ setuptools ];

  dependencies = with pythonPackages; [
    click
    fints
    requests
    mt-940
  ];

  doCheck = false; # no tests

  pythonImportsCheck = [ "pretix_banktool" ];

  meta = {
    description = "Automatic bank data upload tool for pretix (with FinTS client)";
    homepage = "https://github.com/pretix/pretix-banktool";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ hexa ];
    mainProgram = "pretix-banktool";
  };
})
