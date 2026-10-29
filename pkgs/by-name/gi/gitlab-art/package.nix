{
  lib,
  fetchFromGitHub,
  python3Packages,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "gitlab-art";
  version = "0.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kosma";
    repo = "gitlab-art";
    tag = "v${finalAttrs.version}";
    hash = "sha256-j1MdkZUGMfrzowdhjJKhZqwN07JusaJsGkFu78IFdTY=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    pyaml
    platformdirs
    click
    python-gitlab
  ];

  meta = {
    description = "Pull cross-project Gitlab artifact dependencies";
    homepage = "https://github.com/kosma/gitlab-art";
    changelog = "https://github.com/kosma/gitlab-art/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.wtfpl;
    maintainers = with lib.maintainers; [ tbaldwin ];
    mainProgram = "art";
  };
})
