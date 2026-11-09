{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "makejinja";
  version = "2.9.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mirkolenz";
    repo = "makejinja";
    tag = "v${finalAttrs.version}";
    hash = "sha256-V6Xa+akL2sQlfdbIzpm77El7jgeWuPXgVwNLfExutVA=";
  };

  build-system = with python3Packages; [ uv-build ];

  dependencies =
    with python3Packages;
    [
      frozendict
      jinja2
      pyyaml
      rich-click
      typed-settings
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
    changelog = "https://github.com/mirkolenz/makejinja/blob/${finalAttrs.src.rev}/CHANGELOG.md";
  };
})
