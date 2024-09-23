{
  lib,
  python3Packages,
  podman,
  fetchPypi,
  ansible-lint,
}:
python3Packages.buildPythonApplication rec {
  pname = "ansible-navigator";
  version = "24.7.0";
  pyproject = true;

  disabled = python3Packages.pythonOlder "3.10";

  src = fetchPypi {
    inherit version;
    pname = "ansible_navigator";
    hash = "sha256-XMwJzDxo/VZ+0qy5MLg/Kw/7j3V594qfV+T6jeVEWzg=";
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
    changelog = "https://github.com/ansible/ansible-navigator/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ melkor333 ];
  };
}
