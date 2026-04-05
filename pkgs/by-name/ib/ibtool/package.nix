{
  lib,
  fetchFromGitHub,
  python3Packages,
  icu,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "ibtool";
  version = "1.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "viraptor";
    repo = "ibtool";
    tag = finalAttrs.version;
    hash = "sha256-O2CCuM34U5EbqgkFXs/vokM2Q1bv5mqBgFqfhDP463Y=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    lxml
  ];

  runtimeDependencies = [
    icu
  ];

  meta = {
    description = "Apple's ibtool reimplementation";
    homepage = "https://github.com/viraptor/ibtool";
    license = [ lib.licenses.mit ];
    mainProgram = "ibtool";
    maintainers = [ lib.maintainers.viraptor ];
  };
})
