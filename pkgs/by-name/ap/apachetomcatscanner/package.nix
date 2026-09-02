{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "apachetomcatscanner";
  version = "3.8.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "p0dalirius";
    repo = "ApacheTomcatScanner";
    tag = finalAttrs.version;
    hash = "sha256-9gaue/XfxtU+5URYfg+uYaNcx8G3Eu9DgVEpj/lk8TY=";
  };

  patches = [
    # fix compatibility with urllib3 2.x
    ./urllib3-default-ciphers-attributeerror.patch
  ];

  pythonRelaxDeps = [
    "requests"
    "urllib3"
  ];

  build-system = with python3.pkgs; [ setuptools ];

  propagatedBuildInputs = with python3.pkgs; [
    requests
    sectools
    urllib3
    xlsxwriter
  ];

  # Project has no test
  doCheck = false;

  pythonImportsCheck = [ "apachetomcatscanner" ];

  meta = {
    description = "Tool to scan for Apache Tomcat server vulnerabilities";
    homepage = "https://github.com/p0dalirius/ApacheTomcatScanner";
    changelog = "https://github.com/p0dalirius/ApacheTomcatScanner/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "apachetomcatscanner";
  };
})
