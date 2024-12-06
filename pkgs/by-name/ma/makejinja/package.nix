{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "makejinja";
  version = "2.6.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mirkolenz";
    repo = "makejinja";
    rev = "refs/tags/v${version}";
    hash = "sha256-xrXyXFmh9df04I/zcSvQXsyUPrAvbOyyrhx8RNS3Ojs=";
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
  };
}
