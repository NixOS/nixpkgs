{
  lib,
  pkgs,
  python3Packages,
  podman,
  fetchPypi,
  buildPythonPackage,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "ansible-navigator";
  version = "24.7.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchPypi {
    pname = "ansible_navigator";
    inherit version;
    hash = "sha256-XMwJzDxo/VZ+0qy5MLg/Kw/7j3V594qfV+T6jeVEWzg=";
  };

  build-system = with python3Packages; [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = with python3Packages; [
    ansible-builder
    ansible-runner
    podman
    pkgs.ansible-lint
    jinja2
    jsonschema
    tzdata
    onigurumacffi
  ];

  # Tests want to run in tmux
  doCheck = false;

  pythonImportsCheck = [ "ansible_navigator" ];

  meta = with lib; {
    description = "Text-based user interface (TUI) for Ansible";
    homepage = "https://ansible.readthedocs.io/projects/navigator/";
    changelog = "https://github.com/ansible/ansible-navigator/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ melkor333 ];
  };
}
