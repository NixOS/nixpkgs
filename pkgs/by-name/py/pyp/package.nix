{ lib
, fetchFromGitHub
, python3
, bc
, jq
}:

let
  version = "1.2.0";
in python3.pkgs.buildPythonApplication {
  pname = "pyp";
  inherit version;
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "hauntsaninja";
    repo = "pyp";
    rev = "refs/tags/v${version}";
    hash = "sha256-hnEgqWOIVj2ugOhd2aS9IulfkVnrlkhwOtrgH4qQqO8=";
  };

  nativeBuildInputs = [
    python3.pkgs.flit-core
  ];

  nativeCheckInputs = [
    python3.pkgs.pytestCheckHook
    bc
    jq
  ];

  # without this, the tests fail because they are unable to find the pyp tool
  # itself...
  preCheck = ''
     _OLD_PATH_=$PATH
     PATH=$out/bin:$PATH
  '';

  # And a cleanup
  postCheck = ''
    PATH=$_OLD_PATH_
  '';

  meta = {
    homepage = "https://github.com/hauntsaninja/pyp";
    description = "Easily run Python at the shell";
    changelog = "https://github.com/hauntsaninja/pyp/blob/${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ AndersonTorres ];
  };
}
