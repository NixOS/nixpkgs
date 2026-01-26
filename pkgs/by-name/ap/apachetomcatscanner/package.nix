{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "apachetomcatscanner";
  version = "3.8.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "p0dalirius";
    repo = "ApacheTomcatScanner";
    tag = version;
    hash = "sha256-9gaue/XfxtU+5URYfg+uYaNcx8G3Eu9DgVEpj/lk8TY=";
  };

  postPatch = ''
    replacement=$(printf 'try:\n    %s\nexcept AttributeError:\n    pass' \
      'requests.packages.urllib3.util.ssl_.DEFAULT_CIPHERS += ":HIGH:!DH:!aNULL"')

    for f in apachetomcatscanner/utils/network.py apachetomcatscanner/utils/scan.py; do
      if [ -f "$f" ] && grep -Fq 'requests.packages.urllib3.util.ssl_.DEFAULT_CIPHERS' "$f"; then
        substituteInPlace "$f" \
          --replace-fail 'requests.packages.urllib3.util.ssl_.DEFAULT_CIPHERS += ":HIGH:!DH:!aNULL"' \
          "$replacement"
      fi
    done
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

  meta = {
    description = "Tool to scan for Apache Tomcat server vulnerabilities";
    homepage = "https://github.com/p0dalirius/ApacheTomcatScanner";
    changelog = "https://github.com/p0dalirius/ApacheTomcatScanner/releases/tag/${version}";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "apachetomcatscanner";
  };
}
