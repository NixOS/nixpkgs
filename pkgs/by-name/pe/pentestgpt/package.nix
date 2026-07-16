{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "pentestgpt";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "GreyDGL";
    repo = "PentestGPT";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DSjFrl3/vd/lCBWCuGsxYRhDJPWkq249C8g1XBnfKXw=";
  };

  build-system = with python3.pkgs; [ hatchling ];

  dependencies = with python3.pkgs; [
    anthropic
    claude-agent-sdk
    langfuse
    pydantic
    pydantic-settings
    python-dotenv
    rich
    textual
  ];

  # Tests require network access
  doCheck = false;

  pythonImportsCheck = [ "pentestgpt" ];

  meta = {
    description = "GPT-empowered penetration testing tool";
    homepage = "https://github.com/GreyDGL/PentestGPT";
    changelog = "https://github.com/GreyDGL/PentestGPT/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
