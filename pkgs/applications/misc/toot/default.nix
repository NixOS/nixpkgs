{ lib, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "toot";
  version = "0.36.0";

  src = fetchFromGitHub {
    owner  = "ihabunek";
    repo   = "toot";
    rev = "refs/tags/${version}";
    sha256 = "sha256-gEQA9PASSKAMqulOaK8ynBXX7BdptY1uwdS1tOf3/Jc=";
  };

  nativeCheckInputs = with python3Packages; [ pytest ];

  propagatedBuildInputs = with python3Packages;
    [ requests beautifulsoup4 future wcwidth urwid psycopg2 ];

  checkPhase = ''
    py.test
  '';

  meta = with lib; {
    description = "Mastodon CLI interface";
    homepage    = "https://github.com/ihabunek/toot";
    license     = licenses.gpl3;
    maintainers = [ maintainers.matthiasbeyer ];
  };

}

