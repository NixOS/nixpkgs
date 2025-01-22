{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "replacement";
  version = "0.4.4";

  disabled = python3Packages.isPy27;

  src = fetchFromGitHub {
    owner = "siriobalmelli";
    repo = "replacement";
    rev = "v${version}";
    sha256 = "0j4lvn3rx1kqvxcsd8nhc2lgk48jyyl7qffhlkvakhy60f9lymj3";
  };

  propagatedBuildInputs = with python3Packages; [
    ruamel-yaml
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    sh
  ];

  meta = with lib; {
    homepage = "https://github.com/siriobalmelli/replacement";
    description = "Tool to execute yaml templates and output text";
    mainProgram = "replacement";
    longDescription = ''
      Replacement is a python utility
      that parses a yaml template and outputs text.

      A 'template' is a YAML file containing a 'replacement' object.

      A 'replacement' object contains a list of blocks,
      each of which is executed in sequence.

      This tool is useful in generating configuration files,
      static websites and the like.
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ siriobalmelli ];
  };
}
