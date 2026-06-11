{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "semble";
  version = "0.3.3";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "MinishLab";
    repo = "semble";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AZJYGrYrvAa+qm95lU8Dz1Gq+bHUgrGay8chgZzhs68=";
  };

  build-system = with python3Packages; [
    setuptools
    setuptools-scm
  ];

  env.SETUPTOOLS_SCM_PRETEND_VERSION = finalAttrs.version;

  dependencies =
    with python3Packages;
    [
      bm25s
      model2vec
      numpy
      orjson
      pathspec
      questionary
      tree-sitter
      tree-sitter-language-pack
      vicinity
    ]
    ++ finalAttrs.passthru.optional-dependencies.mcp;

  passthru.optional-dependencies = with python3Packages; {
    mcp = [
      mcp
      watchfiles
    ];
  };

  pythonImportsCheck = [ "semble" ];

  meta = {
    description = "Fast and accurate code search for agents";
    homepage = "https://github.com/MinishLab/semble";
    changelog = "https://github.com/MinishLab/semble/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.gdifolco ];
    mainProgram = "semble";
  };
})
