{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "search-vulns";
  version = "0.8.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ra1nb0rn";
    repo = "search_vulns";
    tag = "v${version}";
    hash = "sha256-lvFx+ozbw7cYAJvaEFkeFxG+CfvbvDO0VRuNJ/Ub+bA=";
    fetchSubmodules = true;
  };

  pythonRelaxDeps = [ "cpe-search" ];

  build-system = with python3.pkgs; [ hatchling ];

  dependencies = with python3.pkgs; [
    aiohttp
    aiolimiter
    cpe-search
    cvss
    requests
    tqdm
    ujson
  ];

  optional-dependencies = with python3.pkgs; {
    all = [
      aiohttp
      aiolimiter
      cpe-search
      cvss
      flask
      gevent
      gunicorn
      mariadb
      markdown
      requests
      tqdm
      ujson
    ];
    mariadb = [ mariadb ];
    web = [
      flask
      gevent
      gunicorn
      markdown
    ];
  };

  pythonImportsCheck = [ "search_vulns" ];

  # Re-evaluate with the next release
  doCheck = false;

  meta = {
    description = "Search for known vulnerabilities in software using software titles or a CPE 2.3 string";
    homepage = "https://github.com/ra1nb0rn/search_vulns";
    changelog = "https://github.com/ra1nb0rn/search_vulns/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "search_vulns";
  };
}
