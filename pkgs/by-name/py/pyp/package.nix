{ lib
, fetchFromGitHub
, python3
, bc
, jq
}:

let
  version = "1.1.0";
in python3.pkgs.buildPythonApplication {
  pname = "pyp";
  inherit version;
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "hauntsaninja";
    repo = "pyp";
    rev = "v${version}";
    hash = "sha256-A1Ip41kxH17BakHEWEuymfa24eBEl5FIHAWL+iZFM4I=";
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
