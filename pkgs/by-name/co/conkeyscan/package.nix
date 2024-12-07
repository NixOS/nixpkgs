{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "conkeyscan";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "CompassSecurity";
    repo = "conkeyscan";
    tag = "v${version}";
    hash = "sha256-xYCms+Su7FmaG7KVHZpzfD/wx9Gepz11t8dEK/YDfvI=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "{{VERSION_PLACEHOLDER}}" "${version}"
  '';

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    atlassian-python-api
    beautifulsoup4
    clize
    loguru
    pysocks
    random-user-agent
    readchar
    requests-ratelimiter
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "conkeyscan" ];

  meta = with lib; {
    description = "Tool to scan Confluence for keywords";
    homepage = "https://github.com/CompassSecurity/conkeyscan";
    changelog = "https://github.com/CompassSecurity/conkeyscan/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "conkeyscan";
  };
}
