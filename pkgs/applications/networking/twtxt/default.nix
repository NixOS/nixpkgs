{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "twtxt";
  version = "1.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "buckket";
    repo = "twtxt";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-CbFh1o2Ijinfb8X+h1GP3Tp+8D0D3/Czt/Uatd1B4cw=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    aiohttp
    click
    humanize
    python-dateutil
    setuptools
  ];

  nativeCheckInputs = with python3.pkgs; [ pytestCheckHook ];

  pythonImportsCheck = [ "twtxt" ];

  disabledTests = [
    # Disable test using relative date and time
    "test_tweet_relative_datetime"
  ];

  meta = with lib; {
    description = "Decentralised, minimalist microblogging service for hackers";
    homepage = "https://github.com/buckket/twtxt";
    changelog = "https://github.com/buckket/twtxt/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ siraben ];
    mainProgram = "twtxt";
  };
}
