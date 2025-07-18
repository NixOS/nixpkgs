{
  lib,
  fetchFromGitHub,
  python312,
}:

python312.pkgs.buildPythonApplication rec {
  pname = "routersploit";
  version = "3.4.1-unstable-2025-04-24";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "threat9";
    repo = "routersploit";
    rev = "0bf837f67ed2131077c4192c21909104aab9f13d";
    hash = "sha256-IET0vL0VVP9ZNn75hKdTCiEmOZRHHYICykhzW2g3LEg=";
  };

  build-system = with python312.pkgs; [ setuptools ];

  dependencies = with python312.pkgs; [
    future
    paramiko
    pycryptodome
    pysnmp
    requests
    setuptools
    standard-telnetlib
  ];

  # Tests are out-dated and support for newer pysnmp is not implemented yet
  doCheck = false;

  nativeCheckInputs = with python312.pkgs; [
    pytest-xdist
    pytestCheckHook
    threat9-test-bed
  ];

  postInstall = ''
    mv $out/bin/rsf.py $out/bin/rsf
  '';

  pythonImportsCheck = [ "routersploit" ];

  pytestFlagsArray = [
    # Run the same tests as upstream does in the first round
    "tests/core/"
    "tests/test_exploit_scenarios.py"
    "tests/test_module_info.py"
  ];

  meta = with lib; {
    description = "Exploitation Framework for Embedded Devices";
    homepage = "https://github.com/threat9/routersploit";
    license = licenses.bsd3;
    maintainers = with maintainers; [
      fab
      thtrf
    ];
    mainProgram = "rsf";
  };
}
