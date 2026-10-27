{
  lib,
  python3Packages,
  fetchFromGitHub,
  nix-update-script,
  yamlpath,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "gitlabform";
  version = "6.2.4";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "gitlabform";
    repo = "gitlabform";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dld97rLe5ADkYAuAIGFsDs12ffs+bxj23EZkgnW3TzM=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'requires = ["hatchling==1.32.4"]' 'requires = ["hatchling"]'
  '';

  build-system = [
    python3Packages.hatchling
  ];

  pythonRelaxDeps = true;

  dependencies =
    with python3Packages;
    [
      certifi
      cli-ui
      gql
      jinja2
      luddite
      markupsafe
      mergedeep
      packaging
      python-gitlab
      requests
      rich
      ruamel-yaml
      yamlpath
    ]
    ++ python3Packages.python-gitlab.optional-dependencies.graphql;

  pythonImportsCheck = [
    "gitlabform"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Specialized configuration as a code tool for GitLab";
    homepage = "https://github.com/gitlabform/gitlabform";
    changelog = "https://github.com/gitlabform/gitlabform/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drupol ];
    mainProgram = "gitlabform";
  };
})
