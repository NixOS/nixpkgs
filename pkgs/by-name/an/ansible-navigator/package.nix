{
  lib,
  python3Packages,
  podman,
  fetchPypi,
  ansible-lint,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "ansible-navigator";
  version = "25.12.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) version;
    pname = "ansible_navigator";
    hash = "sha256-i6yw282NWUaCZBtAYi3rQsLk+GGyp8QHyqBi7nwwIlo=";
  };

  build-system = with python3Packages; [
    setuptools
    setuptools-scm
  ];

  dependencies = with python3Packages; [
    ansible-builder
    ansible-runner
    jinja2
    jsonschema
    tzdata
    pyyaml
    onigurumacffi
    ansible-lint
    podman
  ];

  # Tests want to run in tmux
  doCheck = false;

  pythonImportsCheck = [ "ansible_navigator" ];

  meta = {
    description = "Text-based user interface (TUI) for Ansible";
    homepage = "https://ansible.readthedocs.io/projects/navigator/";
    changelog = "https://github.com/ansible/ansible-navigator/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ melkor333 ];
  };
})
