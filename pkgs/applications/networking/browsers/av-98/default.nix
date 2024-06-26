{
  lib,
  python3Packages,
  fetchgit,
}:

python3Packages.buildPythonApplication rec {
  pname = "av-98";
  version = "1.0.2dev";

  src = fetchgit {
    url = "https://tildegit.org/solderpunk/AV-98.git";
    rev = "96cf8e13fe5714c8cdc754f51eef9f0293b8ca1f";
    sha256 = "09iskh33hl5aaif763j1fmbz7yvf0yqsxycfd41scj7vbwdsbxl0";
  };

  propagatedBuildInputs = with python3Packages; [
    ansiwrap
    cryptography
  ];

  # No tests are available
  doCheck = false;
  pythonImportsCheck = [ "av98" ];

  meta = with lib; {
    homepage = "https://tildegit.org/solderpunk/AV-98";
    description = "Experimental console client for the Gemini protocol";
    mainProgram = "av98";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ehmry ];
  };
}
