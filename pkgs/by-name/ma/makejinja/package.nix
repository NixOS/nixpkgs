{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "makejinja";
  version = "2.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mirkolenz";
    repo = "makejinja";
    rev = "refs/tags/v${version}";
    hash = "sha256-F56y+TxDD/B67ncnBTOd0FZGmXO/zjXitwbk/5aiekM=";
  };

  build-system = with python3Packages; [ poetry-core ];

  dependencies =
    with python3Packages;
    [
      jinja2
      pyyaml
      rich-click
      typed-settings
      immutables
    ]
    ++ typed-settings.optional-dependencies.attrs
    ++ typed-settings.optional-dependencies.cattrs
    ++ typed-settings.optional-dependencies.click;

  preCheck = ''
    substituteInPlace pyproject.toml \
        --replace-fail "--cov makejinja --cov-report term-missing" ""
  '';

  nativeCheckInputs = with python3Packages; [ pytestCheckHook ];

  meta = {
    description = "Generate entire directory structures using Jinja templates with support for external data and custom plugins";
    homepage = "https://github.com/mirkolenz/makejinja";
    license = lib.licenses.mit;
    mainProgram = "makejinja";
    maintainers = with lib.maintainers; [
      tomasajt
      mirkolenz
    ];
    platforms = lib.platforms.darwin ++ lib.platforms.linux;
  };
}
