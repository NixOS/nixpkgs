{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "makejinja";
  version = "2.8.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mirkolenz";
    repo = "makejinja";
    tag = "v${version}";
    hash = "sha256-vK5MJb4n3/NmkohpJ1shEexvjHlEAfwZJWy2oL+rzRk=";
  };

  build-system = with python3Packages; [ setuptools ];

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

  nativeCheckInputs = with python3Packages; [
    pytest-cov-stub
    pytestCheckHook
  ];

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
    changelog = "https://github.com/mirkolenz/makejinja/blob/${src.tag}/CHANGELOG.md";
  };
}
