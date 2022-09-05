{ lib, fetchFromGitHub, buildPythonApplication, aiohttp, python-dateutil, humanize, click, pytestCheckHook, tox }:

buildPythonApplication rec {
  pname = "twtxt";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "buckket";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-AdM95G2Vz3UbVPI7fs8/D78BMxscbTGrCpIyyHzSmho=";
  };

  # Relax some dependencies
  postPatch = ''
    substituteInPlace setup.py \
      --replace 'aiohttp>=2.2.5,<3' 'aiohttp' \
      --replace 'click>=6.7,<7' 'click' \
      --replace 'humanize>=0.5.1,<1' 'humanize'
  '';

  propagatedBuildInputs = [ aiohttp python-dateutil humanize click ];

  checkInputs = [ pytestCheckHook tox ];

  disabledTests = [
     # Disable test using relative date and time
     "test_tweet_relative_datetime"
  ];

  meta = with lib; {
    description = "Decentralised, minimalist microblogging service for hackers";
    homepage = "https://github.com/buckket/twtxt";
    license = licenses.mit;
    maintainers = with maintainers; [ siraben ];
  };
}
