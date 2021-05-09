{ lib, setuptools, boto3, requests, click, pyyaml, pydantic, buildPythonApplication
, pythonOlder, fetchFromGitHub, awscli }:

buildPythonApplication rec {
  pname = "nimbo";
  version = "0.2.4";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "nimbo-sh";
    repo = pname;
    rev = "v${version}";
    sha256 = "1fs28s9ynfxrb4rzba6cmik0kl0q0vkpb4zdappsq62jqf960k24";
  };

  propagatedBuildInputs = [ setuptools boto3 awscli requests click pyyaml pydantic ];

  # nimbo tests require an AWS instance
  doCheck = false;
  pythonImportsCheck = [ "nimbo" ];

  meta = with lib; {
    description = "Run machine learning jobs on AWS with a single command";
    homepage = "https://github.com/nimbo-sh/nimbo";
    license = licenses.bsl11;
    maintainers = with maintainers; [ alex-eyre noreferences ];
  };
}
