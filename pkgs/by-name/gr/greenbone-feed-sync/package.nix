{
  lib,
  python3,
  fetchFromGitHub,
  pkgs,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "greenbone-feed-sync";
  version = "25.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "greenbone";
    repo = "greenbone-feed-sync";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lpbbAODk/uLg1nbSPj9Ico5/8klM5Fm5tyXeRQao7N8=";
  };

  build-system = with python3.pkgs; [ poetry-core ];

  dependencies = with python3.pkgs; [
    rich
    shtab
  ];

  nativeCheckInputs = with python3.pkgs; [
    pkgs.rsync
    pontos
    pytestCheckHook
  ];

  pythonImportsCheck = [ "greenbone.feed.sync" ];

  meta = {
    description = "Tool for downloading the Greenbone Community Feed";
    homepage = "https://github.com/greenbone/greenbone-feed-sync";
    changelog = "https://github.com/greenbone/greenbone-feed-sync/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "greenbone-feed-sync";
  };
})
