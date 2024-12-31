{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication rec {
  pname = "criticality_score";
  version = "1.0.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-5XkVT0blnLG158a01jDfQl1Rx9U1LMsqaMjTdN7Q4QQ=";
  };

  propagatedBuildInputs = with python3Packages; [
    pygithub
    python-gitlab
  ];

  doCheck = false;

  pythonImportsCheck = [ "criticality_score" ];

  meta = with lib; {
    description = "Python tool for computing the Open Source Project Criticality Score";
    mainProgram = "criticality_score";
    homepage = "https://github.com/ossf/criticality_score";
    changelog = "https://github.com/ossf/criticality_score/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ wamserma ];
  };
}
