{ stdenv, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  version = "0.25.2";
  name    = "toot-${version}";

  src = fetchFromGitHub {
    owner  = "ihabunek";
    repo   = "toot";
    rev    = version;
    sha256 = "0g18x8pbwhk2d3aphah6dqqbhz62k48pwx63flsnqd4brccd0jkh";
  };

  checkInputs = with python3Packages; [ pytest ];

  propagatedBuildInputs = with python3Packages;
    [ requests beautifulsoup4 future wcwidth urwid ];

  checkPhase = ''
    py.test
  '';

  meta = with stdenv.lib; {
    description = "Mastodon CLI interface";
    homepage    = "https://github.com/ihabunek/toot";
    license     = licenses.mit;
    maintainers = [ maintainers.matthiasbeyer ];
  };

}

