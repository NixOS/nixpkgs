{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  licomp,

  # tests
  pytestCheckHook,
  jsonschema,
}:

buildPythonPackage (finalAttrs: {
  pname = "licomp-dwheeler";
  version = "0.5.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "hesa";
    repo = "licomp-dwheeler";
    tag = finalAttrs.version;
    hash = "sha256-p6BSedKqauJCVpkr18UN6oNLwI2NknfJx8FHBIbi3I4=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    licomp
  ];

  nativeCheckInputs = [
    pytestCheckHook
    jsonschema
  ];

  pythonImportsCheck = [
    "licomp_dwheeler"
  ];

  meta = {
    description = "Implementation of Licomp using David Wheeler's graph";
    homepage = "https://github.com/hesa/licomp-dwheeler";
    changelog = "https://github.com/hesa/licomp-dwheeler/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [
      cc-by-sa-30
      gpl3Plus
    ];
    maintainers = with lib.maintainers; [ eljamm ];
    teams = with lib.teams; [ ngi ];
  };
})
