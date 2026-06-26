{
  lib,
  fetchFromGitHub,
  python3Packages,
  icu,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "ibtool";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "viraptor";
    repo = "ibtool";
    tag = finalAttrs.version;
    hash = "sha256-vFjB+eDw8RP28UGzmc2Sbes8/qNEj1W5fzB6Lnjx6ZI=";
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
