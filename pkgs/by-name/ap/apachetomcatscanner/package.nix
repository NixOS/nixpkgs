{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "apachetomcatscanner";
  version = "3.7.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "p0dalirius";
    repo = "ApacheTomcatScanner";
    rev = "refs/tags/${version}";
    hash = "sha256-mzpJq0er13wcekTac3j4cnRokHh6Q0seM8vwZsM2tN8=";
  };

  # Posted a PR for discussion upstream that can be followed:
  # https://github.com/p0dalirius/ApacheTomcatScanner/pull/32
  postPatch = ''
    sed -i '/apachetomcatscanner=apachetomcatscanner\.__main__:main/d' setup.py
  '';

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

  meta = with lib; {
    description = "Tool to scan for Apache Tomcat server vulnerabilities";
    homepage = "https://github.com/p0dalirius/ApacheTomcatScanner";
    changelog = "https://github.com/p0dalirius/ApacheTomcatScanner/releases/tag/${version}";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ fab ];
    mainProgram = "ApacheTomcatScanner";
  };
}
