{
  lib,
  fetchFromGitHub,
  python3Packages,
  nix-update-script,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "doc2dash";
  version = "3.1.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "hynek";
    repo = "doc2dash";
    tag = finalAttrs.version;
    hash = "sha256-u6K+BDc9tUxq4kCekTaqQLtNN/OLVc3rh14sVSfPtoQ=";
  };

  build-system = with python3Packages; [
    hatchling
    hatch-vcs
    hatch-fancy-pypi-readme
  ];

  dependencies = with python3Packages; [
    attrs
    beautifulsoup4
    click
    rich
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    pytest-cov-stub
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/hynek/doc2dash/releases/tag/${finalAttrs.src.tag}";
    description = "Create docsets for Dash.app-compatible API browsers";
    homepage = "https://doc2dash.hynek.me";
    license = with lib.licenses; [ mit ];
    maintainers = [ lib.maintainers.pyrox0 ];
    mainProgram = "doc2dash";
  };
})
