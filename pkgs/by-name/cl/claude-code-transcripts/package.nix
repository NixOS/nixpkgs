{
  lib,
  python3Packages,
  fetchFromGitHub,
  nix-update-script,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "claude-code-transcripts";
  version = "0.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "simonw";
    repo = "claude-code-transcripts";
    tag = finalAttrs.version;
    hash = "sha256-MCs8B00K/D4rO4kWi3PlATo44rvBlQWYF7gU2c5tFrk=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml --replace-fail 'uv_build>=0.9.7,<0.10.0' 'uv_build'
  '';

  build-system = with python3Packages; [ uv-build ];
  dependencies = with python3Packages; [
    click
    click-default-group
    httpx
    jinja2
    markdown
    questionary
  ];

  pythonImportsCheck = [ "claude_code_transcripts" ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    pytest-httpx
    syrupy
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tools for publishing transcripts for Claude Code sessions";
    homepage = "https://github.com/simonw/claude-code-transcripts";
    changelog = "https://github.com/simonw/claude-code-transcripts/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    mainProgram = "claude-code-transcripts";
    maintainers = with lib.maintainers; [ winter ];
  };
})
