{
  lib,
  python3Packages,
  podman,
  fetchPypi,
  ansible-lint,
}:
python3Packages.buildPythonApplication rec {
  pname = "ansible-navigator";
<<<<<<< HEAD
  version = "25.12.0";
=======
  version = "25.11.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  disabled = python3Packages.pythonOlder "3.10";

  src = fetchPypi {
    inherit version;
    pname = "ansible_navigator";
<<<<<<< HEAD
    hash = "sha256-i6yw282NWUaCZBtAYi3rQsLk+GGyp8QHyqBi7nwwIlo=";
=======
    hash = "sha256-PPSEEEUCX58/c3Iz1NMqCtfvOI5YBPTSoigTw/Ur4Zg=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
