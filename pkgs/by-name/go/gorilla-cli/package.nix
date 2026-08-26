{
  lib,
  python3,
  fetchFromGitHub,
  nix-update-script,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "gorilla-cli";
  version = "0.0.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gorilla-llm";
    repo = "gorilla-cli";
    tag = finalAttrs.version;
    hash = "sha256-3h3QtBDKswTDL7zNM2C4VWiGCqknm/bxhP9sw4ieIcQ=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    requests
    halo
    prompt-toolkit
  ];

  passthru.updateScript = nix-update-script { };

  # no tests
  doCheck = false;

  meta = {
    description = "LLMs for your CLI";
    homepage = "https://github.com/gorilla-llm/gorilla-cli";
    changelog = "https://github.com/gorilla-llm/gorilla-cli/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ happysalada ];
    mainProgram = "gorilla";
  };
})
