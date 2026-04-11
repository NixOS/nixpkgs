{
  lib,
  fetchFromGitHub,
  python3Packages,
  icu,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "actool";
  version = "1.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "viraptor";
    repo = "actool";
    tag = finalAttrs.version;
    hash = "sha256-HWi+MM0jMfg+nPiNFa3dG3sRuSEnS84+h3s6YRcxcAs=";
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
