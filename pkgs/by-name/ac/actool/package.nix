{
  lib,
  fetchFromGitHub,
  python3Packages,
  icu,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "actool";
  version = "1.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "viraptor";
    repo = "actool";
    tag = finalAttrs.version;
    hash = "sha256-8v2P6Z1ZOP65M30+7dTtfXvD0dvaKYSLA9aaP2uzA7E=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    pillow
    liblzfse
    icu
  ];

  meta = {
    description = "Apple's actool reimplementation";
    homepage = "https://github.com/viraptor/actool";
    license = [ lib.licenses.mit ];
    mainProgram = "actool";
    maintainers = [ lib.maintainers.viraptor ];
  };
})
