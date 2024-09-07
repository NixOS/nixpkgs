{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "packj";
  version = "0.15-beta";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ossillate-inc";
    repo = "packj";
    rev = "refs/tags/v${version}";
    hash = "sha256-OWcJE2Gtjgoj9bCGZcHDfAFLWRP4wdENeJAnILMdUXY=";
  };

  preBuild = ''
    export HOME=$(mktemp -d)
  '';

  nativeBuildInputs = with python3.pkgs; [
    setuptools
    wheel
  ];

  propagatedBuildInputs = with python3.pkgs; [
    asttokens
    colorama
    django
    dnspython
    esprima
    func-timeout
    github3-py
    gitpython
    networkx
    protobuf
    pyisemail
    python-dateutil
    python-gitlab
    python-magic
    pytz
    pyyaml
    rarfile
    requests
    six
    tldextract
  ];

  pythonImportsCheck = [
    "packj"
  ];

  meta = with lib; {
    description = "Tool to detect malicious/vulnerable open-source dependencies";
    homepage = "https://github.com/ossillate-inc/packj";
    changelog = "https://github.com/ossillate-inc/packj/releases/tag/v${version}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
    mainProgram = "packj";
  };
}
