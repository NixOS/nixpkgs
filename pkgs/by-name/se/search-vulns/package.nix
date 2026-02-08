{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "search-vulns";
  version = "1.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ra1nb0rn";
    repo = "search_vulns";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xdZq4Er+0CT59Iv0mEcmkZcUM+xbBi/x+TtBNCiyhbY=";
    fetchSubmodules = true;
  };

  pythonRelaxDeps = [ "cpe-search" ];

  build-system = with python3.pkgs; [ hatchling ];

  dependencies = with python3.pkgs; [
    aiohttp
    aiolimiter
    cpe-search
    cvss
    pydantic
    requests
    tqdm
    ujson
    univers
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
      pydantic
      requests
      tqdm
      ujson
      univers
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
    changelog = "https://github.com/ra1nb0rn/search_vulns/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "search_vulns";
  };
})
