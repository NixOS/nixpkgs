{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "sqlmc";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "malvads";
    repo = "sqlmc";
    tag = version;
    hash = "sha256-8p+9A1j+J3WItc1u8kG7LHY086kcwMGhEMENym2p/Fo=";
  };

  nativeBuildInputs = with python3.pkgs; [ setuptools ];

  propagatedBuildInputs = with python3.pkgs; [
    aiohttp
    aiosignal
    attrs
    beautifulsoup4
    frozenlist
    idna
    multidict
    pyfiglet
    soupsieve
    tabulate
    yarl
  ];

  pythonImportsCheck = [ "sqlmc" ];

  meta = {
    description = "Tool to check URLs of a domain for SQL injections";
    homepage = "https://github.com/malvads/sqlmc";
    changelog = "https://github.com/malvads/sqlmc/releases/tag/${version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "sqlmc";
  };
}
